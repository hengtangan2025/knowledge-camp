module KnowledgeCampApi
  class PlansController < ApplicationController
    include KnowledgeNetPlanStore

    def index
      display Plan.where(:net_id => params.require(:net_id))
    end

    def show
      display Plan.find(params[:id])
    end
  end
end
