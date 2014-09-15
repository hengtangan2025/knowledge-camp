module CourseEditor
  class TutorialsController < ApplicationController
    layout 'course_editor/editor', :only => ['edit']

    def new
      @topic = topic
      @tutorial = @topic.tutorials.build
    end

    def update
      tutorial = KnowledgeNetPlanStore::Tutorial.find(params[:id])
      tutorial.update_attributes(allowed_params)
      redirect_to tutorial
    end

    def create
      tutorial = topic.tutorials.create(allowed_params.merge(:creator => current_user))
      redirect_to tutorial.topic
    end

    def edit
      @tutorial = KnowledgeNetPlanStore::Tutorial.find params[:id]
      @topic = @tutorial.topic
      @net = KnowledgeNetStore::Net.first

      # 创建起始页面
      if @tutorial.steps.blank?
        @tutorial.steps.create
      end
    end

    private

    def allowed_params
      params.require(:tutorial).permit(:title, :desc, :image, {:point_ids => []})
    end

    def topic
      KnowledgeNetPlanStore::Topic.find(params[:topic_id])
    end
  end
end
