
# import net
net_json_file_path = "../nets.json"

net_json = IO.read(File.expand_path(net_json_file_path, __FILE__))
net_hash_arr = JSON.parse(net_json)

net_hash_id__to__net = {}
net_id_arr = []
net_hash_arr.each do |net_hash|
  net_name = net_hash["name"]
  json = net_hash.to_json
  net = KnowledgeNetStore::Net.from_json(net_name, "", json)
  net.plans.create!(:title => net.name + "_plan")
  net_hash_id__to__net[net_hash["id"]] = net
  net_id_arr << net.id.to_s
end

# import topic
topic_json_file_path = "../topics.json"
topic_json = IO.read(File.expand_path(topic_json_file_path, __FILE__))
topic_hash_arr = JSON.parse(topic_json)


tutorial_hash_id__to__topic = {}
topic_hash_arr.each do |topic_item|
  plan = net_hash_id__to__net[topic_item["net_id"]].plans.first

  topic = plan.topics.create!(:title => topic_item["title"], :desc => topic_item["desc"])
  topic_item["tutorials"].each do |tutorial_id|
    tutorial_hash_id__to__topic[tutorial_id] = topic
  end
end


# import tutorials
tutorials_json_file_path = "../tutorials.json"
tutorials_json = IO.read(File.expand_path(tutorials_json_file_path, __FILE__))
tutorials_item_arr = JSON.parse(tutorials_json)


tutorials_hash_id__to__tutorial_id = {}

tutorials_item_arr.each do |tutorials_item|
  topic = tutorial_hash_id__to__topic[tutorials_item["id"]]

  tutorial = topic.tutorials.create!(:title => tutorials_item["title"], :desc => tutorials_item["desc"])

  steps = tutorials_item["steps"].map do |step_item|
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


# import sp-tutorials
sp_tutorials_json_file_path = "../sp-tutorials.json"
sp_tutorials_json = IO.read(File.expand_path(sp_tutorials_json_file_path, __FILE__))
sp_tutorials_item_arr = JSON.parse(sp_tutorials_json)

sp_tutorials_hash_id__to__tutorial_id = {}
sp_tutorials_item_arr.each do |sp_tutorials_item|
  topic = tutorial_hash_id__to__topic[sp_tutorials_item["id"]]
  tutorial = topic.tutorials.create!(:title => sp_tutorials_item["title"], :desc => sp_tutorials_item["desc"])

  step_hash_id__to__step_id = {}
  steps = sp_tutorials_item["steps"].map do |step_item|
    step = tutorial.steps.create!(
      :title => step_item["data"]["title"],
      :desc => step_item["data"]["desc"]
    )
    step_hash_id__to__step_id[step_item["id"]] = step.id.to_s
  end

  sp_tutorials_item["steps"].map do |step_item|
    id = step_hash_id__to__step_id[step_item["id"]]
    step = KnowledgeCamp::Step.find(id)

    if step_item["continue"] == "end"
      step.continue_type = :end
      step.continue = :end
    elsif step_item["continue"]["id"] != nil
      step.continue_type = :id
      step.continue = {:id => step_hash_id__to__step_id[step_item["continue"]["id"]]}
    else
      question = step_item["continue"]["select"]["question"]
      options = step_item["continue"]["select"]["options"]
      options = options.map do |option|
        {:id => step_hash_id__to__step_id[option["id"]], :title => option["text"]}
      end

      step.continue_type = :select
      step.continue = {
        :select => {
          :question => question,
          :options  => options
        }
      }
    end
    step.save!
  end


  sp_tutorials_item["related"].each do |point_name|
    point = KnowledgeNetStore::Point.where(:name => point_name, :net_id.in => net_id_arr).first
    tutorial.points << point
  end
  sp_tutorials_hash_id__to__tutorial_id[sp_tutorials_item["id"]] = tutorial.id.to_s

end

p "import success!!!!!!"
