module Explore
  class IndexController < ApplicationController
    before_filter -> {
      if mobile?
        request.format = :mobile
      end
    }

    def index
      @topics = Explore::Mock.topics

      unless mobile?
        # @learning_tutorials = current_user.learning_tutorials
        @learning_tutorials = KnowledgeNetPlanStore::Tutorial.page(1).per(5)

        @newest_topics = KnowledgeNetPlanStore::Topic.limit(4)
      end
    end
  end
end