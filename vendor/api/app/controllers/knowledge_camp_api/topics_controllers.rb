module KnowledgeCampApi
  class TopicsController < ApplicationController
    include KnowledgeNetPlanStore

    def index
      display Topic.where(:plan_id => params[:plan_id])
    end

    def show
      display Topic.find(params[:id])
    end
  end
end
