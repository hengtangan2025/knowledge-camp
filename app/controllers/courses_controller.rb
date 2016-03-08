class CoursesController < ApplicationController
  layout "new_version_base"

  def show
    @page_name = 'course_show'

    course = KcCourses::Course.find params[:id]
    @component_data = course.to_detail_component_data self
    render :page
  end
end
