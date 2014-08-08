module KnowledgeCampApi
  class PointsController < ApplicationController
    include KnowledgeNetStore

    def index
      display Point.where(:net_id => params.require(:net_id))
    end

    def show
      display Point.find(params[:id])
    end
  end
end
