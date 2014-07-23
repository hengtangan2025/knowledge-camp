module Explore
  class PointCell < Cell::Rails
    helper :application

    def list(points, view)
      @view = view
      @points = points
      render
    end
  end
end