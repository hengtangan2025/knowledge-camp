module Explore
  class TopicsController < ApplicationController
    layout -> {
      unless mobile?
        'explore/application'
      end
    }

    before_filter -> {
      if mobile?
        request.format = :mobile
      end
    }

    def index
      unless mobile?
        if params[:net_id].present?
          @net = KnowledgeNetStore::Net.find params[:net_id]
          @topics = @net.topics
        else
          @net = nil
          @topics = KnowledgeNetPlanStore::Topic.all
        end
        
        @nets = KnowledgeNetStore::Net.all
      end
    end

    def mine
      unless mobile?
        @learning_topics = KnowledgeNetPlanStore::Topic.all
        @learning_tutorials = current_user.learning_tutorials
      end
    end

    def show
      if mobile?
        topics = Explore::Mock.topics
        @topic = topics.select {|x| x.id == params[:id]}.first
        
        tutorials = Explore::Mock.tutorials
        @tutorials = @topic.tutorials.map {|id|
          tutorials.select {|t| t.id == id}.first
        }

        return
      end

      @topic = KnowledgeNetPlanStore::Topic.find params[:id]
      @tutorials = @topic.tutorials
    end
  end
end