module Explore
  class PointsController < ApplicationController
    def index
      @net = KnowledgeNetStore::Net.find params[:net_id]
    end
  end
end