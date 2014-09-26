module CourseEditor
  class TutorialCell < Cell::Rails
    helper :application

    def list(tutorials, view)
      @tutorials = tutorials
      @view = view
      render
    end
  end
end