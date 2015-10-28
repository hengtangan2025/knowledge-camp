module ImportSampleData
  class Topic
    JSON_PATH = File.expand_path("../../data/topics.json", __FILE__)

    def self.url_to_file(url)
      tf = Tempfile.new(["tmp", ".png"])
      tf.binmode
      tf << open(url).read
      tf.rewind
      tf
    end

    def self.import
      p "start import topics.json ..."
      net_hash_id__to__net = ImportSampleData::Net.net_hash_id__to__net

      topic_json = IO.read(JSON_PATH)
      topic_hash_arr = JSON.parse(topic_json)

      tutorial_hash_id__to__topic = {}
      topic_hash_arr.each do |topic_item|
        plan = net_hash_id__to__net[topic_item["net_id"]].plans.first

        img = url_to_file(topic_item["img"])
        topic = plan.topics.create!(:title => topic_item["title"], :desc => topic_item["desc"], :image => img)
        img.close

        topic_item["tutorials"].each do |tutorial_id|
          tutorial_hash_id__to__topic[tutorial_id] = topic
        end
      end
      p "topics.json import success !"
    end

    def self.tutorial_hash_id__to__topic
      net_hash_id__to__net = ImportSampleData::Net.net_hash_id__to__net

      topic_json = IO.read(JSON_PATH)
      topic_hash_arr = JSON.parse(topic_json)

      tutorial_hash_id__to__topic = {}
      topic_hash_arr.each do |topic_item|
        plan = net_hash_id__to__net[topic_item["net_id"]].plans.first
        topic = plan.topics.where(:title => topic_item["title"]).first
        topic_item["tutorials"].each do |tutorial_id|
          tutorial_hash_id__to__topic[tutorial_id] = topic
        end
      end

      tutorial_hash_id__to__topic
    end
  end
end
