class KnowledgeNetsController < ApplicationController
  def index
    # @nets = KnowledgeNetStore::Net.all
    redirect_to '/'
  end

  def new
    @net = KnowledgeNetStore::Net.new
  end

  def create
    @net = KnowledgeNetStore::Net.new(_net_params)
    if @net.save
      return redirect_to :action => :index
    end
    redirect_to :action => :new
  end

  def edit
    @net = KnowledgeNetStore::Net.find(params[:id])
  end

  def update
    @net = KnowledgeNetStore::Net.find(params[:id])
    @net.update_attributes(_net_params)
    redirect_to :action => :index
  end

  def destroy
    @net = KnowledgeNetStore::Net.find(params[:id])
    @net.destroy
    redirect_to :action => :index
  end

  def show
    @net = KnowledgeNetStore::Net.find(params[:id])
  end

  private
  def _net_params
    params.require(:knowledge_net_store_net).permit(:name, :desc)
  end
end
