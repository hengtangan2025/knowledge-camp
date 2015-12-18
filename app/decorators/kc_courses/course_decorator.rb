KcCourses::Course.class_eval do
  has_many :course_attachments, inverse_of: :course

  scope :hot, -> {recent}
end

