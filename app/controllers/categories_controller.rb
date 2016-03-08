class CategoriesController < ApplicationController
  layout "new_version_base"

  def show
    @page_name = 'courses'

    cs = KcCourses::CourseSubject.find params[:id]
    courses = cs.courses.page(params[:page])
    # TODO 分页信息
    @component_data = {
      courses: courses.map{|course| course.to_brief_component_data self},
      paginate: {
        total_pages: courses.total_pages,
        current_page: courses.current_page,
        per_page: courses.limit_value
      }
    }

    render :page
  end
end
