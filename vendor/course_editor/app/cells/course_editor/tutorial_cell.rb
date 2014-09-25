module CourseEditor
  class TutorialCell < Cell::Rails
    helper :application

    def list(tutorials)
      @tutorials = tutorials
      render
    end
  end
end