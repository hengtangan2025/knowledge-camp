class Manager::CourseSubjectsController < Manager::ApplicationController

  def index
    @page_name = "manager_csubjects"
    subjects = KcCourses::CourseSubject.all
    items = subjects.map do |_cs|
      DataFormer.new(_cs)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
    @component_data = {
      subjects: items,
      create_subject_url: manager_course_subjects_path,
    }
    render "/mockup/page"
  end

  def create
    cs = KcCourses::CourseSubject.new subject_params
    save_model(cs) do |_cs|
      DataFormer.new(_cs)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def update
    cs = KcCourses::CourseSubject.find params[:id]

    update_model(cs, subject_params) do |_cs|
      DataFormer.new(_cs)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def destroy
    cs = KcCourses::CourseSubject.find params[:id]
    cs.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  private
  def subject_params
    params.require(:subject).permit(:name, :parent_id)
  end
end
