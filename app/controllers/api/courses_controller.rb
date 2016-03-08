class Api::CoursesController < Api::ApplicationController
  def add_fav
    course = KcCourses::Course.find params[:id]
    bucket = current_user.get_default_bucket
    bucket.add_resource course
    # bucket.include_resource? course
    render json: {fav: true}
  end
  
  def remove_fav
    course = KcCourses::Course.find params[:id]
    bucket = current_user.buckets.where(name: '默认').first_or_create
    bucket.remove_resource course
    render json: {fav: false}
  end
end