class TutorialsController < PlanStoreController
  set_model Tutorial

  def create
    @topic = Topic.find params[:topic_id]
    tutorial = @topic.tutorials.create model_params
    redirect_to "/tutorials/#{tutorial.id}"
  end

  update_with  {redirect_to "/tutorials/#{@tutorial.id}"}
  destroy_with {redirect_to "/topics/#{@tutorial.topic.id}"}
end
