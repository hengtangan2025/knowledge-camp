class Bank::IndexController < Bank::ApplicationController
  def index
    @learning_courses = current_user.courses.page.per(2)

    @recommend_courses = KcCourses::Course.page

    @recent_courses = KcCourses::Course.page.per(10)

    @hot_courses = KcCourses::Course.page.per(10)
  end
end
