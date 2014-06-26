class Manage::PointsController < BaseGenericController
  set_model KnowledgeNetStore::Point,
    :allow_attrs  => [:name, :desc, {:parent_ids => []}]

  def index
    @net = KnowledgeNetStore::Net.find(params[:net_id])
  end

  def new
    @net = KnowledgeNetStore::Net.find(params[:net_id])
    render :form
  end

  def edit
    render :form
  end

  def create
    @net = KnowledgeNetStore::Net.find(params[:net_id])
    @point = @net.points.build(model_params)
    if @point.save
      return redirect_to [:manage, @net, :points]
    end
    render :form
  end

  update_with do
    redirect_to @point.net
  end

  destroy_with do
    redirect_to @point.net
  end

end