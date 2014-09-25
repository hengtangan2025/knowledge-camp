class TopicLearnProgress
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, :type => Integer

  belongs_to :user
  belongs_to :topic, :class_name => "KnowledgeNetPlanStore::Topic"

  validates :topic_id, :user_id, :presence => true
  validates :topic_id, :uniqueness => {:scope => :user_id}
  validates :value, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 100,
    :allow_nil => true
  }

  module TopicMethods
    extend ActiveSupport::Concern

    included {
      has_many :topic_learn_progresses, :dependent => :destroy
    }
  end

  module UserMethods
    extend ActiveSupport::Concern

    included {
      has_many :topic_learn_progresses, :dependent => :destroy
    }

    def started_topics(offset: 0, limit: 0)
      query_topics_with_progress(:offset => offset, :limit => limit)
    end

    def learning_topics(offset: 0, limit: 0)
      query_topics_with_progress(:op         => {
                                   :value.gt => 0,
                                   :value.lt => 100
                                 },
                                 :offset => offset,
                                 :limit  => limit)
    end

    def learnt_topics(offset: 0, limit: 0)
      query_topics_with_progress(:op     => {:value => 100},
                                 :offset => offset,
                                 :limit  => limit)
    end

    private

    def query_topics_with_progress(op: {:value.gt => 0}, offset: 0, limit: 0)
      self.topic_learn_progresses
          .where(op)
          .skip(offset)
          .limit(limit)
          .map(&:topic)
    end
  end

  module TutorialLearnProgressMethods
    extend ActiveSupport::Concern

    included {
      after_save :update_topic_progress!
      after_destroy :update_topic_progress!
    }

    def update_topic_progress!
      return if self.topic.blank?

      tutorial_ids = self.topic.tutorial_ids

      progress = self.topic.topic_learn_progresses.find_or_create_by(:user_id => user.id)

      learnt_tutorials = TutorialLearnProgress.where(:value.gt => 0, :tutorial_id.in => tutorial_ids)
      learnt = learnt_tutorials.pluck(:value).reduce(&:+).to_f / 100 * learnt_tutorials.size
      total  = tutorial_ids.size.to_f

      progress.value = ((learnt / total) * 100).round

      progress.save
    end
  end

  TutorialLearnProgress.send        :include, TutorialLearnProgressMethods
  KnowledgeNetPlanStore::Topic.send :include, TopicMethods
end
