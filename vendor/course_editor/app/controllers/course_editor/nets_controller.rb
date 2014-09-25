module CourseEditor
  class NetsController < ApplicationController
    def show
      @net = KnowledgeNetStore::Net.find params[:id]
      @topics = @net.topics
    end
  end
end
