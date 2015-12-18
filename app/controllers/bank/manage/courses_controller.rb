class Bank::Manage::CoursesController < Bank::Manage::ApplicationController
  def index
    @courses = current_user.courses
  end

  def show
    @course = current_user.courses.find params[:id]
    @chapters = @course.chapters
    @attachments = @course.course_attachments
  end

  def new
    @course = current_user.courses.new
  end

  def create
    @course = current_user.courses.new course_params
    return redirect_to([:bank, :manage, @course]) if @course.save
    render :action => :new
  end

  def edit
    @course = current_user.courses.find(params[:id])
  end


  def update
    @course = current_user.courses.find(params[:id])
    return redirect_to([:bank, :manage, @course]) if @course.update_attributes course_params
    render :action => :new
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy
    redirect_to [:bank, :manage, :courses]
  end

  def publish
    @course = current_user.courses.find(params[:id])
    redirect_to [:bank, :manage, :courses] if @course.publish!
  end

  private
  def course_params
    params.require(:course).permit(:title, :desc, :cover)
  end
end
