class TutorialLearnProgress
  include Mongoid::Document
  include Mongoid::Timestamps

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

  def percentage
    "#{value}%"
  end

  module UserMethods
    extend ActiveSupport::Concern

    included {
      has_many :tutorial_learn_progresses
    }

    def started_tutorials(offset: 0, limit: -1)
      query_tutorials_with_progress(:offset => offset, :limit => limit)
    end

    def learning_tutorials(offset: 0, limit: -1)
      query_tutorials_with_progress(:op       => {
                                      :value.gt => 0,
                                      :value.lt => 100
                                    },
                                    :offset   => offset,
                                    :limit    => limit)
    end

    def learnt_tutorials(offset: 0, limit: -1)
      query_tutorials_with_progress(:op       => {:value => 100},
                                    :offset   => offset,
                                    :limit    => limit)
    end

    private

    def query_tutorials_with_progress(op: {:value.gt => 0}, offset: 0, limit: -1)
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
    }

    def update_tutorial_progress!
      return if step.stepped_type != KnowledgeNetPlanStore::Tutorial.name

      tutorial = step.stepped

      return if !tutorial || tutorial.steps.blank?

      progress = user.tutorial_learn_progresses
                     .find_or_create_by(:tutorial_id => tutorial.id)

      return if progress.value

      learnt = user.learn_records.select {|record|
        record.step.stepped_id == tutorial.id
      }.size

      total = tutorial.steps.size

      progress.value = (learnt / total).round * 100

      progress.save
    end
  end
end
