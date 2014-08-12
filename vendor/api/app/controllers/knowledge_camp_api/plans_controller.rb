module KnowledgeCampApi
  class PlansController < ApplicationController
    def index
      display KnowledgeNetPlanStore::Plan.where(:net_id => params.require(:net_id))
    end

    def show
      display KnowledgeNetPlanStore::Plan.find(params[:id])
    end
  end
end
