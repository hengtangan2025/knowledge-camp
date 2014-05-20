class KnowledgePointsController < ApplicationController
  before_filter :pre_load
  def pre_load
    @net = KnowledgeNetStore::Net.find(params[:knowledge_net_id])
  end

  def new
    @point =  KnowledgeNetStore::Point.new
  end

  def create
  end
end