class PointCell < Cell::Rails
  helper :application

  def grid(points)
    @points = points
    render
  end

  def list(points)
    @points = points
    render
  end
end