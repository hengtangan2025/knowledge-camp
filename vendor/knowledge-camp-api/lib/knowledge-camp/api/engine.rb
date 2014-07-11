module KnowledgeCamp
  module Api
    class Engine < ::Rails::Engine
      isolate_namespace KnowledgeCamp::Api
    end
  end
end
