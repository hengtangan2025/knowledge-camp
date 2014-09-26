module CourseEditor
  class LayoutCell < Cell::Rails
    helper :application

    def htmlhead
      render
    end
  end
end