module Explore
  class TutorialsController < ApplicationController
    layout 'explore/tutorial', :only => [:show]

    def index
      @net = KnowledgeNetStore::Net.find params[:net_id]
      redirect_to @net
    end

    def show
    end
  end
end