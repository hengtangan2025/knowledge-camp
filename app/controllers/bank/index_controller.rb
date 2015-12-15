class Bank::IndexController < Bank::ApplicationController
  def index
    # FIXME TODO page.per(2) 返回是数组，非scope，暂时不能添加翻页
    @learning_courses = current_user ? KcCourses::Course.published.studing_of_user(current_user).page : []
    @recommend_courses = KcCourses::Course.published.page
    @recent_courses = KcCourses::Course.recent.published.page.per(10)
    @hot_courses = KcCourses::Course.hot.published.page.per(10)
  end
end
