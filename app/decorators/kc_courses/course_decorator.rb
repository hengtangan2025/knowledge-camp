KcCourses::Course.class_eval do
  scope :hot, -> {recent}
end

