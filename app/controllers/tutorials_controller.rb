class TutorialsController < ApplicationController
  include KnowledgeNetPlanStore

  def new
    @tutorial = Tutorial.new
  end

  def create
    @topic = Topic.find params[:topic_id]
    tutorial = @topic.tutorials.create tutorial_params
    redirect_to "/tutorials/#{tutorial.id}"
  end

  def update
    tutorial = Tutorial.find(params[:id])
    tutorial.update_attributes tutorial_params
    tutorial.save
    redirect_to "/tutorials/#{tutorial.id}"
  end

  def show
    @tutorial = Tutorial.find(params[:id])
  end

  def destroy
    tutorial = Tutorial.find(params[:id])
    tutorial.destroy
    redirect_to "/topics/#{tutorial.topic.id}"
  end

  private

  def tutorial_params
    params.require(:tutorial).permit(:name, :desc)
  end
end
