module CourseFormer
  extend ActiveSupport::Concern

  included do

    former 'KcCourses::Course' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :desc
      field :updated_at
      field :price, ->(instance) {'免费'}

      logic :instructor, ->(instance){
        instance.creator.name
      }

      logic :subjects, ->(instance){
        instance.course_subjects.map do |subject|
          {name: subject.name, url: subject_path(subject.id.to_s)}
        end
      }

      logic :progress,->(instance, user){
        instance.read_percent_of_user(user)
      }

      logic :effort, ->(instance){
        video_count = instance.statistic_info[:video][:count]
        total_minute = instance.statistic_info[:video][:total_minute]
        "#{video_count} 个视频，合计 #{total_minute} 分钟"
      }

      logic :published, ->(instance){
        !instance.published_course.blank? && instance.published_course.enabled
      }

      url :manager_contents_url, ->(instance){
        organize_manager_course_path(instance)
      }

      url :publish_url, ->(instance, options){
        publish_manager_published_courses_path(options)
      }

      url :recall_url, ->(instance, options){
        recall_manager_published_courses_path(options)
      }

      url :url, ->(instance){
        course_path(instance.published_course)
      }
    end

  end
end
