class Old::Sample::PointsController < ApplicationController
  def show
    points = Explore::Mock.nets.map(&:points).flatten

    @point = points.select {|x|
      x.id.to_s == params[:id]
    }.first
    @tutorials = Explore::Mock.tutorials
    @learners = Explore::Mock.learners
  end
end
