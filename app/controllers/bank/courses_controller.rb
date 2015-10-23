class Bank::CoursesController < Bank::ApplicationController
  def index
    @courses = KcCourses::Course.all
  end

  def show
    @course = KcCourses::Course.find params[:id]
  end
end
