class TopicsController < ApplicationController
  include KnowledgeNetPlanStore

  def new
    @topic = Topic.new
  end

  def create
    @plan = Plan.find params[:plan_id]
    topic = @plan.topics.create topic_params
    redirect_to "/topics/#{topic.id}"
  end

  def update
    topic = Topic.find(params[:id])
    topic.update_attributes topic_params
    topic.save
    redirect_to "/topics/#{topic.id}"
  end

  def show
    @topic = Topic.find(params[:id])
    @tutorials = @topic.tutorials
  end

  def destroy
    topic = Topic.find(params[:id])
    topic.destroy
    redirect_to "/plans/#{topic.plan.id}"
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :desc)
  end
end
