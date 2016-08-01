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
   
    _str = current_user.favorite_courses.include?(course.course)? "取消收藏" : "收藏"
    @component_data["favorite_bar_data"] ={}
    @component_data["favorite_bar_data"]["num"] = course.course.favorited_count
    @component_data["favorite_bar_data"]["str"] = _str
    @component_data["favorite_bar_data"]["course_id"] = params[:id]

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

  def exchange_favorite_course
    p "-->"
    course = KcCourses::PublishedCourse.find(params["course_id"]).course
    if current_user.favorite_courses.include?(course)
      current_user.cancel_favorite_course(course)
      render json:{count:course.favorited_count, str:"收藏"}
    else
      current_user.set_favorite_course(course)
      render json:{count:course.favorited_count, str:"取消收藏"}
    end
  end

end
