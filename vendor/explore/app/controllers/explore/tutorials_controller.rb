module Explore
  class TutorialsController < ApplicationController
    layout 'explore/tutorial', :only => [:show, :points]

    def _preload
      @tutorials = Explore::Mock.tutorials
      @tutorial = @tutorials.select {|x| x.id.to_s == params[:id]}.first
    end

    def show
      _preload
      @active = :base

      @parents = @tutorial.parents.map {|pid|
        @tutorials.select {|x| x.id.to_s == pid}.first
      }

      @children = @tutorials.select { |x|
        x.parents.include? @tutorial.id.to_s
      }

      @net = Explore::Mock.nets.select {|x| x.id.to_s == @tutorial.net_id}.first
    
    end

    def points
      _preload
      @active = :points

      nets = Explore::Mock.nets
      points = nets.map {|x| x.points}.flatten
      @points = points.select {|x|
        @tutorial.related.include? x.name
      }
    end
  end
end