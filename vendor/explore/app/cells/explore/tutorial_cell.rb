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

    def list_with_title(tutorials, title, view)
      @tutorials = tutorials
      @title = title
      @view = view
      render
    end

    def learning(tutorials, user)
      @tutorials = tutorials
      @user = user
      render
    end

    def web_list(tutorials)
      @tutorials = tutorials
      render
    end

    def web_blocks(step)
      @step = step
      render
    end
  end
end