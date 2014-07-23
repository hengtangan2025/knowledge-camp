module Explore
  class NetCell < Cell::Rails
    helper :application

    def header(net)
      @net = net
      render
    end

    def tab(net, active, view)
      @net = net
      @active = active
      @view = view
      render
    end
  end
end