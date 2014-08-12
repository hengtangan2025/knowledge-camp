module Explore
  class NetsController < ApplicationController
    def show
      nets = Explore::Mock.nets
      @net = nets.select {|x| x.id.to_s == params[:id]}.first
      @tutorials = Explore::Mock.tutorials.select {|x| x.net_id == @net.id}
      @tutorials[0..2].each {|x| x.learned = true}
    end
  end
end