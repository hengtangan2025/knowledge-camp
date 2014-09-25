module Explore
  class PointCell < Cell::Rails
    helper :application

    def list(points, view)
      @view = view
      @points = points
      render
    end

    def web_list(points)
      @points = points
      render
    end
  end
end