module CourseEditor
  class NetsController < ApplicationController
    def show
      @net = KnowledgeNetStore::Net.find params[:id]
      @topics = KnowledgeNetPlanStore::Topic.all
    end
  end
end