class Bank::CoursesController < Bank::ApplicationController
  def index
    @courses = KcCourses::Course.all
  end

  def show
    @course = KcCourses::Course.find params[:id]
  end

  def mine
    @learning_courses = current_user.courses.page

    @bucket = current_user.buckets.where(name: '默认').first_or_create
    @fav_courses = @bucket.courses.page

    @completed_courses = current_user.courses.page
  end
end
