module Explore
  class TutorialsController < ApplicationController
    layout 'explore/tutorial', :only => [:show]

    def index
      @net = KnowledgeNetStore::Net.find params[:net_id]
      redirect_to @net
    end

    def show
      @tutorials = Explore::Mock.tutorials
      @tutorial = @tutorials.select {|x| x.id.to_s == params[:id]}.first
      @parents = @tutorial.parents.map {|pid|
        @tutorials.select {|x| x.id.to_s == pid}.first
      }
    end
  end
end