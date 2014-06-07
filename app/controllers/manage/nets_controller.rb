class Manage::NetsController < ApplicationController
  set_model KnowledgeNetStore::Net,
    :allow_attrs  => [:name, :desc]

  def new
    render :form
  end

  def edit
    render :form
  end

  def create
    @net = KnowledgeNetStore::Net.new(model_params)
    return redirect_to :action => :index if @net.save
    render :form
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

end
