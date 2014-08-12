module Explore
  class TutorialsController < ApplicationController
    layout 'explore/tutorial', :only => [:show]

    def show
      @tutorials = Explore::Mock.tutorials
      @tutorial = @tutorials.select {|x| x.id.to_s == params[:id]}.first
      @parents = @tutorial.parents.map {|pid|
        @tutorials.select {|x| x.id.to_s == pid}.first
      }

      @net = Explore::Mock.nets.select {|x| x.id.to_s == @tutorial.net_id}.first
    end
  end
end