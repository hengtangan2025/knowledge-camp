module CourseEditor
  class TutorialsController < ApplicationController
    layout 'course_editor/editor', :only => ['edit']

    def new
      @topic = KnowledgeNetPlanStore::Topic.find params[:topic_id]

      @tutorial = KnowledgeNetPlanStore::Tutorial.create({
        :topic => @topic,
        :title => "教程 #{Time.now}"  
      })

      redirect_to :back
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
  end
end