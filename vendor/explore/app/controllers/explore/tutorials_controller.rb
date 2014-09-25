module Explore
  class TutorialsController < ApplicationController
    before_filter -> {
      if mobile?
        request.format = :mobile
      end
    }

    def _preload
      @tutorials = Explore::Mock.tutorials
      @tutorial = @tutorials.select {|x| x.id.to_s == params[:id]}.first
    end

    def show
      if mobile?
        _preload
        @active = :base

        @parents = @tutorial.parents.map {|pid|
          @tutorials.select {|x| x.id.to_s == pid}.first
        }

        @children = @tutorials.select { |x|
          x.parents.include? @tutorial.id.to_s
        }

        @net = Explore::Mock.nets.select {|x| x.id.to_s == @tutorial.net_id}.first
      
        return
      end

      @tutorial = KnowledgeNetPlanStore::Tutorial.find params[:id]
      @topic = @tutorial.topic

      @prev_tutorials = @tutorial.parents
      @next_tutorials = @tutorial.children

      # @prev_tutorials = KnowledgeNetPlanStore::Tutorial.all
      # @next_tutorials = KnowledgeNetPlanStore::Tutorial.all

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