class KnowledgeNetsController < ApplicationController
  include GenericControllerHelpers
  set_model KnowledgeNetStore::Net

  def index
    # @nets = KnowledgeNetStore::Net.all
    redirect_to '/'
  end

  def new
    @net = KnowledgeNetStore::Net.new
  end

  def create
    @net = KnowledgeNetStore::Net.new(model_params)
    if @net.save
      return redirect_to :action => :index
    end
    redirect_to :action => :new
  end

  def edit
    @net = KnowledgeNetStore::Net.find(params[:id])
  end

  update_with do
    redirect_to :action => :index
  end

  destroy_with do
    redirect_to :action => :index
  end

  show_with do
    respond_to do |format|
      format.json { render :json => @net.to_json }
      format.html { render }
    end
  end

  def graph
    @net = KnowledgeNetStore::Net.find(params[:id])
    render :layout => false
  end

  private
  def model_params
    params.require(:knowledge_net_store_net).permit(:name, :desc)
  end
end
