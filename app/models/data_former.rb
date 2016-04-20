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
  include EnterpriseLevelFormer

  include Finance::TellerWareFormer
  include Finance::TellerWareScreenFormer
  include Finance::TellerWareTradeFormer

  include QuestionFormer

  def self.paginate_data(models)
    begin
      {
        total_pages: models.total_pages,
        current_page: models.current_page,
        per_page: models.limit_value
      }
    rescue
      {}
    end
  end
end
