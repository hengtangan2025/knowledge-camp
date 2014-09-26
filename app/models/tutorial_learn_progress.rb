class TutorialLearnProgress
  include Mongoid::Document
  include Mongoid::Timestamps
  include TopicLearnProgress::TutorialLearnProgressMethods

  field :value, :type => Integer

  belongs_to :user
  belongs_to :tutorial, :class_name => "KnowledgeNetPlanStore::Tutorial"

  validates :tutorial_id, :user_id, :presence => true
  validates :tutorial_id, :uniqueness => {:scope => :user_id}
  validates :value, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 100,
    :allow_nil => true
  }

  delegate :topic, :to => :tutorial

  module TutorialMethods
    extend ActiveSupport::Concern

    included {
      has_many :tutorial_learn_progresses,
               :class_name => "KnowledgeNetPlanStore::Tutorial"
    }

    def progress_by(user)
      progress = user.tutorial_learn_progresses.where(:tutorial_id => self.id).first
      return 0 if !progress
      progress.value
    end

    def is_learned_by?(user)
      100 == self.progress_by(user)
    end

    module ClassMethods
      def hot_list(since: Time.at(0), limit: 0)
        criteria = TutorialLearnProgress.where(:updated_at.gt => since,
                                               :value.gt      => 0)

        criteria.limit(limit).reduce([]) do |array, progress|
          tutorial = progress.tutorial
          hash = array.find {|h| h[:tutorial].id == tutorial.id}
          updated_at = progress.updated_at

          if hash
            hash[:learned_count] += 1
            hash[:time] = updated_at if hash[:time] < updated_at
          else
            array << {
              :tutorial      => tutorial,
              :learned_count => 1,
              :time          => updated_at
            }
          end

          array
        end.sort do |a, b|
          count = b[:learned_count] <=> a[:learned_count]
          count == 0 ? b[:time] <=> a[:time] : count
        end.map do |h|
          h.delete(:time)
          h
        end
      end
    end
  end

  module UserMethods
    extend ActiveSupport::Concern

    included {
      has_many :tutorial_learn_progresses, :dependent => :destroy
    }

    def started_tutorials(offset: 0, limit: 0)
      query_tutorials_with_progress(:offset => offset, :limit => limit)
    end

    def learning_tutorials(offset: 0, limit: 0)
      query_tutorials_with_progress(:op       => {
                                      :value.gt => 0,
                                      :value.lt => 100
                                    },
                                    :offset   => offset,
                                    :limit    => limit)
    end

    def learnt_tutorials(offset: 0, limit: 0)
      query_tutorials_with_progress(:op       => {:value => 100},
                                    :offset   => offset,
                                    :limit    => limit)
    end

    private

    def query_tutorials_with_progress(op: {:value.gt => 0}, offset: 0, limit: 0)
      self.tutorial_learn_progresses
          .where(op)
          .skip(offset)
          .limit(limit)
          .map(&:tutorial)
    end
  end

  module LearnRecordMethods
    extend ActiveSupport::Concern

    included {
      after_save :update_tutorial_progress!
      after_destroy :update_tutorial_progress!
    }

    def update_tutorial_progress!
      return if step.stepped_type != KnowledgeNetPlanStore::Tutorial.name

      tutorial = step.stepped

      return if !tutorial || tutorial.steps.blank?

      progress = user.tutorial_learn_progresses
                     .find_or_create_by(:tutorial_id => tutorial.id)

      learnt = KnowledgeCamp::LearnRecord.where(:user_id => user.id).select {|record|
        record.step.stepped_id == tutorial.id
      }.size

      total = tutorial.steps.size.to_f

      progress.value = ((learnt / total) * 100).round

      progress.save
    end
  end

  KnowledgeCamp::LearnRecord.send      :include, LearnRecordMethods
  KnowledgeNetPlanStore::Tutorial.send :include, TutorialMethods
end
