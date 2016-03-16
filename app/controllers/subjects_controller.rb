class SubjectsController < ApplicationController
  layout "new_version_base"

  def show
    @page_name = 'courses'

    if params[:id] == "all"
      courses = KcCourses::Course.all.published.page(params[:page])
    else
      cs = KcCourses::CourseSubject.find params[:id]
      courses = cs.courses.published.page(params[:page])
    end

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
