
net_json_file_path = "../knowledge_net_v1.json"
json = IO.read(File.expand_path(net_json_file_path, __FILE__))

net = KnowledgeNetStore::Net.from_json("勺工基本概念及操作技法_v1测试数据", "", json)



tutorial_json_file_path = "../tutorial_v1.json"
json = IO.read(File.expand_path(tutorial_json_file_path, __FILE__))
item_arr = JSON.parse(json)

plan = net.plans.create!(:title => net.name + "_plan")
topic = plan.topics.create!(:title => plan.title + "_topic")

id_kv_hash = {}
item_arr.each do |item|
  tutorial = topic.tutorials.create!(:title => item["title"], :desc => item["desc"])
  item["steps"].each do |step_item|
    step = tutorial.steps.create!(:title => step_item["title"], :desc => step_item["desc"])
  end
  item["related"].each do |point_name|
    point = KnowledgeNetStore::Point.where(:name => point_name, :id => net.id.to_s).first
    tutorial.points << point
  end
  id_kv_hash[item["id"]] = tutorial.id.to_s
end


# 处理 tutorial 关联
item_arr.each do |item|
  children_ids = item["children"].map{|i|id_kv_hash[i]}
  id = id_kv_hash[item["id"]]
  tutorial = KnowledgeNetPlanStore::Tutorial.find(id)
  children_ids.each do |cid|
    c = KnowledgeNetPlanStore::Tutorial.find(cid)
    tutorial.add_child c
  end
end

p "import success!!!!!!"
