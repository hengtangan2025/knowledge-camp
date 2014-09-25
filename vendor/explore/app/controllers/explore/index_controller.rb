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
        @learning_tutorials = current_user.learning_tutorials :limit => 5
        @newest_topics = KnowledgeNetPlanStore::Topic.order_by(:updated_at => :desc).limit(4)

        @hot_tutorials = KnowledgeNetPlanStore::Tutorial.hot_list :limit => 1

        @learning_tutorials = KnowledgeNetPlanStore::Tutorial.page(1).per(5)
      end
    end
  end
end