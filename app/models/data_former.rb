class DataFormer
  include DataFormerConfig
  include Rails.application.routes.url_helpers

  include CourseFormer
  include ChapterFormer
  include WareFormer
  include CourseSubjectFormer
  include UserFormer
end
