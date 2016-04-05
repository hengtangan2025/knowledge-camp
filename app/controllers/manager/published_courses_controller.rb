class Manager::PublishedCoursesController < ApplicationController
  layout "new_version_manager"

  def index
    @page_name = "manager_courses_publish"

    courses = KcCourses::Course.all.page(params[:page])
    data    = courses.map do |course|
      DataFormer.new(course)
        .logic(:instructor)
        .logic(:published)
        .url(:publish_url, :publish_url, course_id: course.id.to_s)
        .url(:recall_url,  :recall_url,  course_id: course.id.to_s)
        .data
    end

    @component_data = {
      prepared_courses: data,
      paginate: {
        total_pages: courses.total_pages,
        current_page: courses.current_page,
        per_page: courses.limit_value
      }
    }
    render "/mockup/page"
  end

  def publish
    course = KcCourses::Course.find params[:course_id]
    course.publish!
    render :status => 200, :json => {:status => 'success'}
  end

  def recall
    course = KcCourses::Course.find params[:course_id]
    course.unpublish!
    render :status => 200, :json => {:status => 'success'}
  end
end
