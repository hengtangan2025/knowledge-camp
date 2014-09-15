module CourseEditor
  class NetsController < ApplicationController
    def show
      @net = KnowledgeNetStore::Net.find params[:id]
    end
  end
end
