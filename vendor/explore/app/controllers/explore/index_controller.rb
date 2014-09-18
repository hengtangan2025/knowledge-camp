module Explore
  class IndexController < ApplicationController
    layout -> {
      if mobile?
        'explore/application.mobile'
      end
    }

    before_filter -> {
      if mobile?
        request.format = :mobile
      end
    }

    def index
      @topics = Explore::Mock.topics

      unless mobile?
        @recommend_topics = @topics
        @newest_topics = @topics
      end
    end
  end
end