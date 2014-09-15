module CourseEditor
  class TopicsController < ApplicationController
    def show
      @topic = KnowledgeNetPlanStore::Topic.find(params[:id])
    end

    def new
      @net = net
      @topic = @net.topics.build
    end

    def edit
      @topic = KnowledgeNetPlanStore::Topic.find(params[:id])
      @net = @topic.net
    end

    def update
      topic = KnowledgeNetPlanStore::Topic.find(params[:id])
      topic.update_attributes(allowed_params)
      redirect_to topic
    end

    def create
      topic = net.topics.create(allowed_params)
      redirect_to topic
    end

    private

    def allowed_params
      params.require(:topic).permit(:title, :desc, :image, {:point_ids => []})
    end

    def net
      KnowledgeNetStore::Net.find(params[:net_id])
    end
  end
end
