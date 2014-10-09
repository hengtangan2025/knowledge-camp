module CourseEditor
  class TutorialsController < ApplicationController
    layout 'course_editor/editor', :only => ['design', 'simple_design']

    def new
      @topic = topic
      @net = @topic.net
      @tutorial = @topic.tutorials.build
    end

    def create
      tutorial = topic.tutorials.create(allowed_params.merge(:creator => current_user))
      redirect_to tutorial.topic
    end

    def edit
      @tutorial = KnowledgeNetPlanStore::Tutorial.find(params[:id])
      @topic = @tutorial.topic
      @net = @topic.net
    end

    def update
      tutorial = KnowledgeNetPlanStore::Tutorial.find(params[:id])
      tutorial.update_attributes(allowed_params)
      redirect_to [:simple_design, tutorial]
    end

    def destroy
      tutorial = KnowledgeNetPlanStore::Tutorial.find(params[:id])
      topic = tutorial.topic
      tutorial.destroy
      redirect_to topic
    end

    def design
      @tutorial = KnowledgeNetPlanStore::Tutorial.find params[:id]
      @topic = @tutorial.topic

      # 创建起始页面
      if @tutorial.steps.blank?
        @tutorial.steps.create
      end
    end

    # 简化的，线性的教程编写
    def simple_design
      @tutorial = KnowledgeNetPlanStore::Tutorial.find params[:id]
      @topic = @tutorial.topic

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
