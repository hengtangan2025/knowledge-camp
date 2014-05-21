class PlansController < PlanStoreController
  set_model Plan

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def create
    plan = Plan.create model_params
    redirect_to "/plans/#{plan.id}"
  end

  update_with  {redirect_to "/plans/#{@plan.id}"}
  show_with    {@topics = @plan.topics}
  destroy_with {redirect_to "/plans"}
end
