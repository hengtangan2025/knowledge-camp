module Explore
  class StepCell < Cell::Rails
    helper :application

    def detail(step, num, count, view)
      @view = view
      @step = step
      @num = num
      @count = count
      render
    end

    def flow_detail(step, view)
      @view = view
      @step = step
      render
    end
  end
end