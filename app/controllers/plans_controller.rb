class PlansController < PlanStoreController
  set_model Plan, :allow_attrs => [:name, :desc, :net_id]

  def new
    render :form
  end

  def edit
    render :form
  end

  def create
    @plan = Plan.new model_params
    return redirect_to :action => :index if @plan.save
    render :form
  end

  update_with  {redirect_to "/plans/#{@plan.id}"}
  show_with    {@topics = @plan.topics}
  destroy_with {redirect_to "/plans"}
end
