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
    course = KcCourses::Course.new course_params
    course.creator = current_user
    if course.save
      render json: manager_courses_create_response_data(course)
    else
      render json: course.errors.messages, :status => 422
    end
  end

  def organize
    course = KcCourses::Course.find params[:id]
    @page_name = 'manager_course_contents'
    @component_data = {
      course: manager_course_contents_component_data(course),
      manager_courses_url: manager_courses_path,
      manager_create_chapter_url: manager_course_chapters_path(course)
    }
    render "/mockup/page"
  end

  private
  def course_params
    params.require(:course).permit(:title, :desc, :cover_file_entity_id)
  end
end
