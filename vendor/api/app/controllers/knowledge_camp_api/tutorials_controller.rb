module KnowledgeCampApi
  class TutorialsController < ApplicationController
    include KnowledgeNetPlanStore

    def index
      display tutorial_collection.map {|t| t.with_learner(current_user)}
    end

    def show
      display Tutorial.find(params[:id]).with_learner(current_user)
    end

    private

    def tutorial_collection
      case query_key
      when :topic_id
        Tutorial.where(:topic_id => params[query_key])
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
      Tutorial.where(:id => params[query_key]).first
    end

    def query_key
      first_key [
        :topic_id,
        :ancestor_id,
        :parent_id,
        :child_id,
        :descendant_id
      ]
    end
  end
end
