module Explore
  class StepsController < ApplicationController
    layout 'explore/tutorial', :only => [:show, :finish]

    def show
    end

    def finish
    end
  end
end