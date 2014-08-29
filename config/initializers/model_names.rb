module KnowledgeNetStore
  class Net
    def self.model_name
      ActiveModel::Name.new(KnowledgeNetStore::Net, nil, 'net')
    end
  end

  class Point
    def self.model_name
      ActiveModel::Name.new(KnowledgeNetStore::Point, nil, 'point')
    end
  end
end

module KnowledgeNetPlanStore
  class Plan
    def self.model_name
      ActiveModel::Name.new(KnowledgeNetPlanStore::Plan, nil, 'plan')
    end
  end

  class Topic
    def self.model_name
      ActiveModel::Name.new(KnowledgeNetPlanStore::Topic, nil, 'topic')
    end
  end

  class Tutorial
    def self.model_name
      ActiveModel::Name.new(KnowledgeNetPlanStore::Tutorial, nil, 'tutorial')
    end
  end
end

module VirtualFileSystem
  class File
    def self.model_name
      ActiveModel::Name.new(VirtualFileSystem::File, nil, 'file')
    end
  end
end

module DocumentsStore
  class Document
    def self.model_name
      ActiveModel::Name.new(DocumentsStore::Document, nil, 'document')
    end
  end
end