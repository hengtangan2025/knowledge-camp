
net_json_file_path = "../knowledge_net_v1.json"
json = IO.read(File.expand_path(net_json_file_path, __FILE__))

net = KnowledgeNetStore::Net.from_json("勺工基本概念及操作技法_v1测试数据_1.1", "", json)



tutorial_json_file_path = "../tutorial_v1.json"
json = IO.read(File.expand_path(tutorial_json_file_path, __FILE__))
item_arr = JSON.parse(json)

plan = net.plans.create!(:title => net.name + "_plan")
topic = plan.topics.create!(:title => plan.title + "_topic")

id_kv_hash = {}
item_arr.each do |item|
  tutorial = topic.tutorials.create!(:title => item["title"], :desc => item["desc"])

  steps = item["steps"].map do |step_item|
    tutorial.steps.create!(:title => step_item["title"], :desc => step_item["desc"])
  end
  steps.each_with_index do |step, index|
    if index+1 != steps.count
      step.continue_type = :id
      step.continue = {:id => steps[index+1].id.to_s}
    else
      step.continue_type = :end
      step.continue = :end
    end
    step.save!
  end

  item["related"].each do |point_name|
    point = KnowledgeNetStore::Point.where(:name => point_name, :net_id => net.id.to_s).first
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





net = KnowledgeNetStore::Net.create!(:name => "测试教程步骤分支逻辑")
point = net.points.create!(:name => "配置JAVA运行环境")
plan = net.plans.create!(:title => net.name + "_plan")
topic = plan.topics.create!(:title => plan.title + "_topic")

tutorial = topic.tutorials.create!(:title => "带有选择分支的教程")
tutorial.points << point

step_1 = tutorial.steps.create!(
  :title => "检查 JAVA 运行环境",
  :desc  => "JAVA 可以运行在不同的操作系统上。在不同操作系统上，JAVA 的配置方法存在着一些区别。"
)
step_2 = tutorial.steps.create!(
  :title => "在 Windows 操作系统中检查 JAVA 运行环境",
  :desc => "点击“运行”，输入 CMD，打开命令行界面。输入 java -version 并回车。如果命令行界面显示以下的返回结果，说明系统已经成功安装配置了 JAVA."
)
step_3 = tutorial.steps.create!(
  :title => "在 Linux/Unix 操作系统中检查 JAVA 运行环境",
  :desc => "打开系统的字符界面，输入 java -version 并回车。如果命令行界面显示以下的返回结果，说明系统已经成功安装配置了 JAVA."
)
step_4 = tutorial.steps.create!(
  :title => "开始开发",
  :desc => "如果运行环境检查正确。就可以开始 JAVA 程序的开发了。",
  :continue_type => :end,
  :continue => :end
)

step_1.continue_type = :select
step_1.continue = {
  :select => {
    :question => "你使用什么操作系统？",
    :options  => [
      {:id => step_2.id.to_s, :title => "Windows"},
      {:id => step_3.id.to_s, :title => "Linux/Unix"}
    ]
  }
}
step_1.save!

step_2.continue_type = :id
step_2.continue = {:id => step_4.id.to_s}
step_2.save!

step_3.continue_type = :id
step_3.continue = {:id => step_4.id.to_s}
step_3.save!

p "import success!!!!!!"
