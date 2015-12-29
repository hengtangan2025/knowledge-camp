KcCourses::Course.class_eval do
  has_many :course_attachments, inverse_of: :course

  scope :hot, -> {recent}

  def related_test_paters
    QuestionBank::TestPaper.recent.limit(5)
  end
end

