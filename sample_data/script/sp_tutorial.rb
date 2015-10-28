module ImportSampleData
  class SpTutorial
    JSON_PATH = File.expand_path("../../data/sp-tutorials.json", __FILE__)

    def self.url_to_file(url)
      tf = Tempfile.new(["tmp", ".png"])
      tf.binmode
      tf << open(url).read
      tf.rewind
      tf
    end

    def self.add_vfileblock(step, kind, url)
      name, path, fe = url_to_file_super(url) do |f|
        FilePartUpload::FileEntity.create(:attach => f)
      end

      FileUtils.rm_rf(path)

      command = VirtualFileSystem::Command(:knowledge_net, User.first)

      vfile = command.put("/" + name, fe.id.to_s, :mode => :default) do |vff|
        vff.net = KnowledgeNetStore::Net.last
        vff.visible_name = name
      end

      block = step.add_content(kind, vfile.id)

      binding.pry if block.errors.any?
    end

    def self.url_to_file_super(url, &block)
      ext  = url.gsub(/\?.*/, "").split(".").last
      name = "#{SecureRandom.hex}.#{ext}"
      path = "/tmp/#{name}"

      open(path, "wb") do |f|
        f << open(URI.escape url).read
        block ? [name, path, block.call(f)] : f
      end
    end

    def self.import
      p "start import sp-tutorials.json ..."
      user = User.where(:name => "user1", :login => "user1").first
      tutorial_hash_id__to__topic = ImportSampleData::Topic.tutorial_hash_id__to__topic
      net_id_arr = KnowledgeNetStore::Net.all.map{|net|net.id.to_s}

      sp_tutorials_item_arr = JSON.parse(IO.read(JSON_PATH))

      sp_tutorials_hash_id__to__tutorial_id = {}
      sp_tutorials_item_arr.each do |sp_tutorials_item|
        topic = tutorial_hash_id__to__topic[sp_tutorials_item["id"]]

        img = url_to_file(sp_tutorials_item["img"])
        tutorial = topic.tutorials.create!(:title => sp_tutorials_item["title"], :desc => sp_tutorials_item["desc"], :image => img, :creator => user)
        img.close

        step_hash_id__to__step_id = {}
        steps = sp_tutorials_item["steps"].map do |step_item|
          step = tutorial.steps.create!(
            :title => step_item["data"]["title"]
          )

          content = step_item["data"]["desc"]
          step.add_content("text", content)

          (step_item["data"]["imgs"] || []).each do |image_url|
            add_vfileblock(step, :image, image_url)
          end

          video = step_item["data"]["video"]
          if !video.blank?
            add_vfileblock(step, :video, video)
          end

          step_hash_id__to__step_id[step_item["id"]] = step.id.to_s
          step
        end

        sp_tutorials_item["steps"].map do |step_item|
          id = step_hash_id__to__step_id[step_item["id"]]
          step = KnowledgeCamp::Step.find(id)

          if step_item["continue"] == "end"
            step.set_continue(false)
          elsif step_item["continue"]["id"] != nil
            next_step_id = step_hash_id__to__step_id[step_item["continue"]["id"]]
            step.set_continue("step", next_step_id)
          else
            question = step_item["continue"]["select"]["question"]
            options = step_item["continue"]["select"]["options"]
            options = options.map do |option|
              {:id => step_hash_id__to__step_id[option["id"]], :text => option["text"]}
            end
            step.set_continue "select", :question => question, :options => options
          end
        end


        sp_tutorials_item["related"].each do |point_name|
          point = KnowledgeNetStore::Point.where(:name => point_name, :net_id.in => net_id_arr).first
          tutorial.points << point
        end
        sp_tutorials_hash_id__to__tutorial_id[sp_tutorials_item["id"]] = tutorial.id.to_s
      end

      p "sp-tutorials.json import success !"
    end
  end
end
