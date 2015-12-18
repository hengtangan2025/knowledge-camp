class Bank::IndexController < Bank::ApplicationController
  def index
    # FIXME TODO page.per(2) 返回是数组，非scope，暂时不能添加翻页
    @learning_courses = current_user ? KcCourses::Course.published.studing_of_user(current_user).page.per(2) : []
    #@recommend_courses = KcCourses::Course.published.page.per(6)
    @recent_courses = KcCourses::Course.recent.published.page.per(8)
    @hot_courses = KcCourses::Course.hot.published.page.per(8)
  end
end
