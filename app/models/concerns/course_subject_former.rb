module CourseSubjectFormer
  extend ActiveSupport::Concern

  included do

    former 'KcCourses::CourseSubject' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :slug
      field :courses_count, ->(instance) {instance.course_ids.count}
      field :parent_id, ->(instance) {
        parent_id = instance.parent_id
        parent_id ? parent_id.to_s : nil
      }

      url :delete_url, ->(instance){
        manager_course_subject_path(instance)
      }

      url :update_url, ->(instance){
        manager_course_subject_path(instance)
      }
      url :search_courses_url, ->(instance){
        select_courses_from_subject_manager_course_path(instance)
      }

    end

  end
end
