module Explore
  class IndexController < ApplicationController
    layout -> {
      if mobile?
        'explore/application.mobile'
      end
    }

    before_filter -> {
      if mobile?
        request.format = :mobile
      end
    }

    def index
      @topics = Explore::Mock.topics

      unless mobile?
        @topics = KnowledgeNetPlanStore::Topic.page(1).per(4)
        @recommend_topics = @topics
        @newest_topics = @topics

        @learning_tutorials = KnowledgeNetPlanStore::Tutorial.page(1).per(5)
      end
    end
  end
end