module CourseEditor
  class StepCell < Cell::Rails
    helper :application

    def blocks(blocks)
      @blocks = blocks
      render
    end
  end
end