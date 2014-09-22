module Explore
  class LayoutCell < Cell::Rails
    helper :application
    
    def nav(options)
      @user = options[:user]
      render
    end

    def htmlhead
      render
    end
  end
end