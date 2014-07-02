class Manage::PointsController < BaseGenericController
  set_model KnowledgeNetStore::Point,
    :allow_attrs  => [:name, :desc, {:parent_ids => []}]

  def index
    @net = KnowledgeNetStore::Net.find(params[:net_id])
  end

  def new
    @net = KnowledgeNetStore::Net.find(params[:net_id])
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
    redirect_to [:manage, @point]
  end

  destroy_with do
    redirect_to @point.net
  end

  # TODO 改成体验更好的形式
  def assign_parent
    @point = KnowledgeNetStore::Point.find params[:id]
    @net = @point.net
  end

  def assign_child
    @point = KnowledgeNetStore::Point.find params[:id]
    @net = @point.net
  end

  def do_assign
    @point = KnowledgeNetStore::Point.find params[:id]

    if params[:parent_ids]
      @point.update_attribute :parent_ids, params[:parent_ids]
      redirect_to [:manage, @point]
      return
    end

    if params[:child_ids]
      @point.update_attribute :child_ids, params[:child_ids]
      redirect_to [:manage, @point]
      return
    end
  end
end