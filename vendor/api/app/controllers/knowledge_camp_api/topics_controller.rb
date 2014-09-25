module KnowledgeCampApi
  class TopicsController < ApplicationController
    def index
      display topic_collection
    end

    def show
      display KnowledgeNetPlanStore::Topic.find(params[:id])
    end

    private

    def topic_collection
      case query_key
      when :net_id
        net = KnowledgeNetStore::Net.find(params[:net_id])
        net.plans.map(&:topics).flatten
      when :plan_id
        KnowledgeNetPlanStore::Topic.where(:plan_id => params[:plan_id])
      when :is_started
        current_user.started_topics
      else
        KnowledgeNetPlanStore::Topic.all
      end || []
    end

    def query_key
      first_key [
        :net_id,
        :point_id,
        :ancestor_id,
        :parent_id,
        :child_id,
        :descendant_id,
        :is_started
      ], true
    end
  end
end
