class Manager::CoursesController < ApplicationController
  layout "new_version_manager"
  include Data::Former

  def index
    @page_name = "manager_courses"
    @component_data = manager_courses_component_data
    render "/mockup/page"
  end

  def new
    @page_name = "manager_new_course"
    @component_data = {
      create_course_url: manager_courses_path
    }
    render "/mockup/page"
  end

  def create
  end
end
