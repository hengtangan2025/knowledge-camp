module CourseEditor
  class TopicsController < ApplicationController
    def new
      @net = KnowledgeNetStore::Net.find params[:net_id]

      @topic = KnowledgeNetPlanStore::Topic.create({
        :title => "教学主题 #{Time.now}"
      })

      redirect_to @net
    end
  end
end