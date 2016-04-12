class SubjectsController < ApplicationController
  layout "new_version_base"

  def show
    @page_name = 'courses'

    if params[:id] == "all"
      courses = KcCourses::PublishedCourse.enabled.page(params[:page])
    else
      cs = KcCourses::CourseSubject.find params[:id]
      courses = cs.courses.published.page(params[:page])
    end

    data = courses.map do |course|
      DataFormer.new(course).url(:url).data
    end

    @component_data = {
      courses: data,
      paginate: {
        total_pages: courses.total_pages,
        current_page: courses.current_page,
        per_page: courses.limit_value
      }
    }

    render :page
  end
end
