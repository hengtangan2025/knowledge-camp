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

  private
  def chapter_params
    params.require(:chapter).permit(:title, :desc)
  end
end
