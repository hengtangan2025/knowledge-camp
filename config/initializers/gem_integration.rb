module KnowledgeNetPlanStore
  Plan.send :belongs_to,
            :net,
            :class_name => "KnowledgeNetStore::Net"

  Tutorial.send :has_and_belongs_to_many,
                :points,
                :class_name => "KnowledgeNetStore::Point"
end

DocumentsStore::Document.belongs_to :net,
                                    :class_name  => "KnowledgeNetStore::Net",
                                    :foreign_key => :net_id

KnowledgeNetStore::Net.has_many :documents,
                                :class_name => "DocumentsStore::Document"
