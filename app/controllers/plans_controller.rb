class PlansController < ApplicationController
  include KnowledgeNetPlanStore

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def create
    plan = Plan.create plan_params
    redirect_to "/plans/#{plan.id}"
  end

  def update
    plan = Plan.find(params[:id])
    plan.update_attributes plan_params
    plan.save
    redirect_to "/plans/#{plan.id}"
  end

  def show
    @plan = Plan.find(params[:id])
    @topics = @plan.topics
  end

  def destroy
    plan = Plan.find(params[:id])
    plan.destroy
    redirect_to "/plans"
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :desc)
  end
end
