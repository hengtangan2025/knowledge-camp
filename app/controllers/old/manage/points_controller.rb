class Old::Manage::PointsController < BaseGenericController
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
      return redirect_to [:old, :manage, @net, :points]
    end
    render :form
  end

  update_with do
    redirect_to [:old, :manage, @point]
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
      new_parents = KnowledgeNetStore::Point.where(:id.in => params[:parent_ids])
      @point.parents = new_parents
    end

    if params[:child_ids]
      new_children = KnowledgeNetStore::Point.where(:id.in => params[:child_ids])
      @point.children = new_children
    end

    redirect_to [:old, :manage, @point]
  end
end
