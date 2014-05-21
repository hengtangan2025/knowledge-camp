class TopicsController < PlanStoreController
  set_model Topic

  def new
    @topic = Topic.new
  end

  def create
    @plan = Plan.find params[:plan_id]
    topic = @plan.topics.create model_params
    redirect_to "/topics/#{topic.id}"
  end

  update_with  {redirect_to "/topics/#{@topic.id}"}
  show_with    {@tutorials = @topic.tutorials}
  destroy_with {redirect_to "/plans/#{@topic.plan.id}"}
end
