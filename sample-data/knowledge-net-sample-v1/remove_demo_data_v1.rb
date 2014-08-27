KnowledgeNetPlanStore::Topic.destroy_all
KnowledgeNetPlanStore::Tutorial.destroy_all
KnowledgeCamp::Step.destroy_all

net_json_file_path = "../nets.json"

net_json = IO.read(File.expand_path(net_json_file_path, __FILE__))
net_hash_arr = JSON.parse(net_json)

net_hash_arr.each do |net_hash|
  net_name = net_hash["name"]
  KnowledgeNetStore::Net.where(:name => net_name).each do |net|
    net.plans.destroy_all
    net.points.destroy_all
    net.destroy
  end
end

p "remove success!!!"
