class KnowledgePointsController < ApplicationController
  include GenericControllerHelpers
  set_model KnowledgeNetStore::Point

  before_filter :pre_load
  def pre_load
    @net = KnowledgeNetStore::Net.find(params[:knowledge_net_id])
  end

  def new
    @point =  KnowledgeNetStore::Point.new
  end

  def create
    @point = @net.points.build(model_params)
    if @point.save
      return redirect_to "/knowledge_nets/#{@net.id}"
    end
    redirect_to :action => :new
  end

  def show
    @point = KnowledgeNetStore::Point.find(params[:id])
  end

  def edit
    @point = KnowledgeNetStore::Point.find(params[:id])
  end

  update_with do
    redirect_to "/knowledge_nets/#{@net.id}"
  end

  destroy_with do
    redirect_to "/knowledge_nets/#{@net.id}"
  end

  private
  def model_params
    params.require(:knowledge_net_store_point).permit(:name, :desc, :parent_ids => [])
  end
end