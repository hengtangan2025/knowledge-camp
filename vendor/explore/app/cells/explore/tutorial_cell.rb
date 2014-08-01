module Explore
  class TutorialCell < Cell::Rails
    helper :application

    def list(tutorials, view)
      @tutorials = tutorials
      render
    end

    def list_finish(tutorials, view)
      @tutorials = tutorials
      render
    end
  end
end