module KnowledgeCampApi
  class TutorialsController < ApplicationController
    include KnowledgeNetPlanStore

    def index
      display Tutorial.where(cond)
    end

    def show
      display Tutorial.find(params[:id])
    end

    private

    def cond
      return {:topic_id => params[:topic_id]} if params[:topic_id]
      return {:prerequisite_tutorial_id => params[:prerequisite_tutorial_id]} if params[:prerequisite_tutorial_id]
      {:followup_tutorial_id => params[:followup_tutorial_id]} if params[:followup_tutorial_id]
    end
  end
end
