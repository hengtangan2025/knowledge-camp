class Manager::ChaptersController < ApplicationController
  layout "new_version_manager"
  include Data::Former

  def create
    course = KcCourses::Course.find params[:course_id]
    chapter = course.chapters.new chapter_params
    chapter.creator = current_user
    if chapter.save
      render json: manager_chapters_create_response_data(chapter)
    else
      render json: chapter.errors.messages, status: 422
    end
  end

  def update
    chapter = KcCourses::Chapter.find params[:id]
    if chapter.update_attributes chapter_params
      render json: manager_chapters_update_response_data(chapter)
    else
      render json: chapter.errors.messages, status: 422
    end
  end

  def move_up
    chapter = KcCourses::Chapter.find params[:id]
    chapter.move_up
    render :status => 200
  end

  def move_down
    chapter = KcCourses::Chapter.find params[:id]
    chapter.move_down
    render :status => 200
  end

  def destroy
    chapter = KcCourses::Chapter.find params[:id]
    chapter.destroy
    render :status => 200
  end

  private
  def chapter_params
    params.require(:chapter).permit(:title, :desc)
  end
end
