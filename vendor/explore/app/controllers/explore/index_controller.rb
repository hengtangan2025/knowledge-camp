module Explore
  class IndexController < ApplicationController
    def index
      @topics = Explore::Mock.topics
    end
  end
end