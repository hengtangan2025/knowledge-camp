class Manage::NetsController < BaseGenericController
  set_model KnowledgeNetStore::Net,
    :allow_attrs  => [:name, :desc]

  def edit
    render :form
  end

  def create
    @net = KnowledgeNetStore::Net.new(model_params)
    return redirect_to [:manage, @net] if @net.save
    render :new
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
