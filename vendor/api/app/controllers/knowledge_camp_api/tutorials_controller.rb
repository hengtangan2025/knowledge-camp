module KnowledgeCampApi
  class TutorialsController < ApplicationController
    def index
      display tutorial_collection.map {|t| t.with_learner(current_user)}
    end

    def show
      display KnowledgeNetPlanStore::Tutorial.find(params[:id]).with_learner(current_user)
    end

    private

    def tutorial_collection
      case query_key
      when :net_id
        net = KnowledgeNetStore::Net.find(params[:net_id])
        net.plans.map(&:topics).flatten.map(&:tutorials).flatten
      when :point_id
        KnowledgeNetStore::Point.find(params[:point_id]).tutorials
      when :topic_id
        KnowledgeNetPlanStore::Topic.find(params[:topic_id]).tutorials
      when :ancestor_id
        base.try :descendants
      when :parent_id
        base.try :children
      when :child_id
        base.try :parents
      when :descendant_id
        base.try :ancestors
      end || []
    end

    def base
      KnowledgeNetPlanStore::Tutorial.find(params[query_key])
    end

    def query_key
      first_key [
        :topic_id,
        :net_id,
        :point_id,
        :ancestor_id,
        :parent_id,
        :child_id,
        :descendant_id
      ]
    end
  end
end
