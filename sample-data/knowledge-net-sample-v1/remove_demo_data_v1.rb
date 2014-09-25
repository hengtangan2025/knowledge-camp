Searchable.enabled_models.each do |model|
  puts "====: 开始导入 #{model.to_s} 的拼音索引"
  model.import :force => true
  model.each(&:save)
  puts "====: 拼音索引导入完毕."
end

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
