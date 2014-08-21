module KnowledgeCampApi
  class TopicsController < ApplicationController
    def index
      plan_id = params[:plan_id]

      if plan_id
        display KnowledgeNetPlanStore::Topic.where(:plan_id => plan_id)
      else
        display KnowledgeNetPlanStore::Topic.all
      end
    end

    def show
      display KnowledgeNetPlanStore::Topic.find(params[:id])
    end
  end
end
