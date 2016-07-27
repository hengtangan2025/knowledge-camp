class SubjectsController < ApplicationController
  layout "new_version_base"

  def show
    @page_name = 'courses'

    if params[:id] == "all"
      courses = KcCourses::PublishedCourse.enabled.page(params[:page])
    else
      courses = KcCourses::PublishedCourse.where(:"data.course_subject_ids".in => [params[:id]],:enabled => true).page(params[:page])
    end

    data = courses.map do |course|
      DataFormer.new(course).url(:url).data
    end

    cs_name_and_id = KcCourses::CourseSubject.all.map do |course_subject|
      {
        id: course_subject.id,
        name: course_subject.name
      }
    end


    @component_data = {
      courses: data,
      course_subjects: cs_name_and_id,
      paginate: {
        total_pages: courses.total_pages,
        current_page: courses.current_page,
        per_page: courses.limit_value
      }
    }

    render :page
  end
end
