module CourseEditor
  class TopicCell < Cell::Rails
    helper :application

    def list(topics)
      @topics = topics
      render
    end
  end
end