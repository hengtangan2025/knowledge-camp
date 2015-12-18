class CourseAttachment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :course, class_name: 'KcCourses::Course', inverse_of: :course_attachments
  belongs_to :file_entity, class_name: 'FilePartUpload::FileEntity'

  validates :file_entity_id, presence: true
end
