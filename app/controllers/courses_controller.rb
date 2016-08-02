class CoursesController < ApplicationController
  layout "new_version_base"

  def show
    @page_name = 'course_show'

    course = KcCourses::PublishedCourse.find params[:id]
    @component_data = DataFormer.new(course)
      .logic(:subjects)
      .logic(:effort)
      .logic(:chapters, current_user)
      .data

    render :page
  end

  def ware
    @page_name = 'ware_show'

    course = KcCourses::PublishedCourse.find params[:course_id]

    course_data = DataFormer.new(course)
      .logic(:subjects)
      .logic(:effort)
      .url(:url)
      .logic(:chapters, current_user)
      .data

    ware = {}
    course_data[:chapters].each do |chapter_info|
      chapter_info[:wares].each do |ware_info|
        if ware_info[:id] == params[:ware_id]
          ware = ware_info
        end
      end
    end
    ware[:current_user] = current_user.id.to_s

    @component_data = {
      comments: [],
      course: course_data,
      ware: ware
    }
    render "mockup/page", layout: "new_version_ware"
  end

  def set_percent
    current_user = User.find(params[:current_user_id])
    ware = KcCourses::Ware.find(params[:ware_id])
    ware.set_read_percent_by_user(current_user,100)
    render json:{id: ware.id}
  end
end
