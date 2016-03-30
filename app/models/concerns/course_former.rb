module CourseFormer
  extend ActiveSupport::Concern

  included do

    former 'KcCourses::Course' do
      brief do
        field :id, ->(instance) {instance.id.to_s}
        field :name
        field :desc
        field :updated_at
        field :price, ->(instance) {'免费'}
      end

      logics do
        logic :instructor, ->(instance){
          instance.creator.name
        }

        logic :subjects, ->(instance){
          instance.course_subjects.map do |subject|
            {name: subject.name, url: subject_path(subject.id.to_s)}
          end
        }

        logic :effort, ->(instance){
          video_count = instance.statistic_info[:video][:count]
          total_minute = instance.statistic_info[:video][:total_minute]
          "#{video_count} 个视频，合计 #{total_minute} 分钟"
        }
      end

      urls do
        url :manager_contents_url, ->(instance){
          organize_manager_course_path(instance)
        }
      end

    end

  end
end
