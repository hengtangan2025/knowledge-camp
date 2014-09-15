module Explore
  class PointsController < ApplicationController
    def index
      nets = Explore::Mock.nets
      @net = nets.select {|x| x.id.to_s == params[:net_id]}.first
    end

    def show
      nets = Explore::Mock.nets
      points = nets.map {|x| x.points}.flatten
      @point = points.select {|x| x.id.to_s == params[:id]}.first
      @net = nets.select {|x| x.points.include? @point}.first

      tutorials = Explore::Mock.tutorials
      @tutorials = tutorials.select {|x| x.related.include? @point.name}
    end
  end
end