module Explore
  class NetsController < ApplicationController
    def show
      nets = Explore::Mock.nets
      @net = nets.select {|x| x.id.to_s == params[:id]}.first
      @tutorials = Explore::Mock.tutorials.select {|x| x.net_id == @net.id}
      # @tutorials[0..2].each {|x| x.learned = true}

      learner = Explore::Mock.learners.first
      @tutorials.each {|x|
        if learner.learned.include? x.id
          x.learned = true
        end
      }

      # render :json => @tutorials.map(&:id)
    end
  end
end