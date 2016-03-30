class Manager::ChaptersController < ApplicationController
  layout "new_version_manager"

  def create
    course = KcCourses::Course.find params[:course_id]
    chapter = course.chapters.new chapter_params
    chapter.creator = current_user

    save_model(chapter) do |c|
      DataFormer.new(c)
        .brief
        .url(:move_down_url)
        .url(:move_up_url)
        .url(:update_url)
        .url(:delete_url)
        .url(:create_ware_url)
        .data
    end
  end

  def update
    chapter = KcCourses::Chapter.find params[:id]

    update_model(chapter, chapter_params) do |c|
      DataFormer.new(c)
        .brief
        .data
    end
  end

  def move_up
    chapter = KcCourses::Chapter.find params[:id]
    chapter.move_up
    render :status => 200, :json => {:status => 'success'}
  end

  def move_down
    chapter = KcCourses::Chapter.find params[:id]
    chapter.move_down
    render :status => 200, :json => {:status => 'success'}
  end

  def destroy
    chapter = KcCourses::Chapter.find params[:id]
    chapter.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  private
  def chapter_params
    params.require(:chapter).permit(:name, :desc)
  end
end
