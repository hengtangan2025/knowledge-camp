class KnowledgePointsController < BaseGenericController
  set_model KnowledgeNetStore::Point,
    :require_name => :knowledge_net_store_point,
    :allow_attrs  => [:name, :desc, {:parent_ids => []}]

  before_filter :pre_load
  def pre_load
    @net = KnowledgeNetStore::Net.find(params[:knowledge_net_id])
  end

  def create
    @point = @net.points.build(model_params)
    if @point.save
      return redirect_to "/knowledge_nets/#{@net.id}"
    end
    redirect_to :action => :new
  end

  update_with do
    redirect_to "/knowledge_nets/#{@net.id}"
  end

  destroy_with do
    redirect_to "/knowledge_nets/#{@net.id}"
  end

end