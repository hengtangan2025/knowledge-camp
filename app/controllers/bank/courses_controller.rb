class Bank::CoursesController < Bank::ApplicationController
  def index
    @courses = KcCourses::Course.published.recent.page(params[:page])
  end

  def show
    @course = KcCourses::Course.published.find params[:id]
  end

  def mine
    redirect_to studying_bank_courses_path
  end

  def hot
    @courses = KcCourses::Course.published.page(params[:page])
    render :index
  end

  def studying
    @courses = KcCourses::Course.studing_of_user(current_user).published.page(params[:page])
  end

  def fav
    @bucket = current_user.buckets.where(name: '默认').first_or_create
    @courses = @bucket.courses.published.page params[:page]
    render :mine_four
  end

  def studied
    @courses = KcCourses::Course.studied_of_user(current_user)
    render :mine_four
  end

  def study
    @course = KcCourses::Course.published.find params[:id]
  end

  def search
    @q = params[:q]
    @courses = @q.blank? ? KcCourses::Course.where(id: []) : KcCourses::Course.standard_search(@q)
    @total = @courses.count
    @courses = @courses.published.page(params[:page])
  end

end
