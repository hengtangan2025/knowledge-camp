require "open-uri"

module ImportSampleData
  class Tutorial
    JSON_PATH = File.expand_path("../../data/tutorials.json", __FILE__)

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
      p "start import tutorials.json ..."
      user = User.where(:name => "user1", :login => "user1").first
      tutorial_hash_id__to__topic = ImportSampleData::Topic.tutorial_hash_id__to__topic
      net_id_arr = KnowledgeNetStore::Net.all.map{|net|net.id.to_s}

      tutorials_item_arr = JSON.parse(IO.read(JSON_PATH))

      tutorials_hash_id__to__tutorial_id = {}

      tutorials_item_arr.each do |tutorials_item|
        topic = tutorial_hash_id__to__topic[tutorials_item["id"]]

        img = url_to_file(tutorials_item["img"])
        tutorial = topic.tutorials.create!(:title => tutorials_item["title"], :desc => tutorials_item["desc"], :image => img, :creator => user)
        img.close

        steps = tutorials_item["steps"].map do |step_item|
          step = tutorial.steps.create!(:title => step_item["title"])


          content = step_item["desc"]
          step.add_content("text", content)

          step_item["imgs"].each do |image_url|
            add_vfileblock(step, :image, image_url)
          end

          video = step_item["video"]
          if !video.blank?
            add_vfileblock(step, :video, video)
          end

          step
        end

        steps.each_with_index do |step, index|
          if index+1 != steps.count
            step.set_continue("step", steps[index+1].id.to_s)
          else
            step.set_continue(false)
          end
        end

        tutorials_item["related"].each do |point_name|
          point = KnowledgeNetStore::Point.where(:name => point_name, :net_id.in => net_id_arr).first
          tutorial.points << point
        end

        tutorials_hash_id__to__tutorial_id[tutorials_item["id"]] = tutorial.id.to_s
      end


      # 处理 tutorial 关联
      tutorials_item_arr.each do |tutorials_item|
        children_ids = tutorials_item["children"].map{|i|tutorials_hash_id__to__tutorial_id[i]}
        id = tutorials_hash_id__to__tutorial_id[tutorials_item["id"]]
        tutorial = KnowledgeNetPlanStore::Tutorial.find(id)
        children_ids.each do |cid|
          c = KnowledgeNetPlanStore::Tutorial.find(cid)
          tutorial.add_child c
        end
      end
      p "tutorials.json import success !"
    end
  end
end
