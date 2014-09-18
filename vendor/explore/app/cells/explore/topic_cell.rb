module Explore
  class TopicCell < Cell::Rails
    helper :application

    def grid(topics)
      @topics = topics
      render
    end
  end
end