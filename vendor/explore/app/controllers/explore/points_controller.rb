module Explore
  class PointsController < ApplicationController
    def index
      @net = KnowledgeNetStore::Net.find params[:net_id]
    end

    def show
      @point = KnowledgeNetStore::Point.find params[:id]
    end
  end
end