module KnowledgeCampApi
  class TopicsController < ApplicationController
    def index
      display KnowledgeNetPlanStore::Topic.where(:plan_id => params.require(:plan_id))
    end

    def show
      display KnowledgeNetPlanStore::Topic.find(params[:id])
    end
  end
end
