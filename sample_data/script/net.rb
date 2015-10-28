module ImportSampleData
  class Net
    JSON_PATH = File.expand_path("../../data/nets.json", __FILE__)

    def self.import
      p "start import nets.json ..."
      user = User.where(:name => "user1", :login => "user1").first

      net_json = IO.read(JSON_PATH)
      net_hash_arr = JSON.parse(net_json)

      net_hash_id__to__net = {}
      net_hash_arr.each do |net_hash|
        net_name = net_hash["name"]
        json = net_hash.to_json
        net = KnowledgeNetStore::Net.from_json(net_name, "", json)
        net.plans.create!(:title => net.name + "_plan")
        net_hash_id__to__net[net_hash["id"]] = net
      end
      p "nets.json import success !"
    end

    def self.net_hash_id__to__net
      net_json = IO.read(JSON_PATH)
      net_hash_arr = JSON.parse(net_json)

      net_hash_id__to__net = {}
      net_hash_arr.each do |net_hash|
        net = KnowledgeNetStore::Net.where(:name => net_hash["name"]).first
        net_hash_id__to__net[net_hash["id"]] = net
      end

      net_hash_id__to__net
    end

    def self.nets
      net_json = IO.read(JSON_PATH)
      net_hash_arr = JSON.parse(net_json)

      net_hash_arr.map do |net_hash|
        KnowledgeNetStore::Net.where(:name => net_hash["name"]).first
      end
    end
  end
end
