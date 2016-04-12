class DataFormer
  include DataFormerConfig

  include CourseFormer
  include ChapterFormer
  include WareFormer
  include CourseSubjectFormer
  include UserFormer
  include PublishedCourseFormer
  include BusinessCategoryFormer
  include EnterprisePostFormer
end
