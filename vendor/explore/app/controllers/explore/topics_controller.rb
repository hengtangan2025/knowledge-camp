module Explore
  class TopicsController < ApplicationController
    # layout 'explore/topics', :only => [:show]

    def show
      topics = Explore::Mock.topics
      @topic = topics.select {|x| x.id == params[:id]}.first
      
      tutorials = Explore::Mock.tutorials
      @tutorials = @topic.tutorials.map {|id|
        tutorials.select {|t| t.id == id}.first
      }
    end
  end
end