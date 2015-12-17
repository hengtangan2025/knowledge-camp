class Bank::Manage::CourseAttachmentsController < Bank::Manage::ApplicationController
  before_filter :set_course, only: [:create, :new]

  def new
    @course_attachment = @course.course_attachments.new
  end

  def create
    @course_attachment = @course.course_attachments.new course_attachment_params
    return redirect_to([:bank, :manage, @course]) if @course_attachment.save
    render :action => :new
  end

  #def edit
    #@course = @course.course_attachments.find(params[:id])
  #end


  #def update
    #@course = @course.course_attachments.find(params[:id])
    #return redirect_to([:bank, :manage, @course]) if @course.update_attributes course_params
    #render :action => :new
  #end

  def destroy
    @course_attachment = CourseAttachment.find(params[:id])
    @course = @course_attachment.course
    @course_attachment.destroy
    redirect_to [:bank, :manage, @course]
  end

  private
  def set_course
    @course = current_user.courses.find(params[:course_id])
  end

  def course_attachment_params
    params.require(:course_attachment).permit(:file_entity_id)
  end
end
