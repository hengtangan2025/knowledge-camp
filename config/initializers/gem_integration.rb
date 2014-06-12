module KnowledgeNetPlanStore
  Plan.send :belongs_to,
            :net,
            :class_name => "KnowledgeNetStore::Net"

  Tutorial.send :has_and_belongs_to_many,
                :points,
                :class_name => "KnowledgeNetStore::Point"
end
