module Explore
  class LayoutCell < Cell::Rails
    def nav(options)
      @user = options[:user]
      render
    end

    def htmlhead
      render
    end
  end
end