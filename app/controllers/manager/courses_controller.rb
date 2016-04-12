class Manager::CoursesController < Manager::ApplicationController

  def index
    @page_name = "manager_courses"
#
    courses = KcCourses::Course.all.page(params[:page])
    data    = courses.map do |course|
      DataFormer.new(course)
        .logic(:instructor)
        .url(:manager_contents_url).data
    end

    @component_data = {
      new_course_url: new_manager_course_path,
      courses: data,
      paginate: {
        total_pages: courses.total_pages,
        current_page: courses.current_page,
        per_page: courses.limit_value
      },
      # 用于生成顶部过滤
      filter_subjects: [
        {name: '电子商务', id: '1'},
        {name: '农产品销售', id: '2'},
      ],
    }

    render "/mockup/page"
  end

  def new
    @page_name = "manager_new_course"
    @component_data = {
      create_course_url: manager_courses_path
    }
    render "/mockup/page"
  end

  def create
    course = KcCourses::Course.new course_params
    course.creator = current_user

    save_model(course) do |c|
      DataFormer.new(c)
        .logic(:instructor)
        .data
        .merge jump_url: organize_manager_course_path(c)
    end
  end

  def organize
    course = KcCourses::Course.find params[:id]
    @page_name = 'manager_course_contents'

    data = DataFormer.new(course)
      .logic(:instructor)
      .logic(:effort)
      .logic(:subjects)
      .relation(:chapters, ->(chapters){
        chapters.map do |chapter|
          DataFormer.new(chapter)
            .url(:update_url)
            .url(:move_down_url)
            .url(:move_up_url)
            .url(:delete_url)
            .url(:create_ware_url)
            .relation(:wares, ->(wares){
              wares.map do |ware|
                DataFormer.new(ware)
                  .logic(:learned, current_user)
                  .url(:url)
                  .url(:update_url)
                  .url(:move_down_url)
                  .url(:move_up_url)
                  .url(:delete_url)
                  .data
              end
            })
            .data
        end
      })
      .data


    @component_data = {
      course: data,
      # course: manager_course_contents_component_data(course),
      manager_courses_url: manager_courses_path,
      manager_create_chapter_url: manager_course_chapters_path(course)
    }
    render "/mockup/page"
  end

  private
  def course_params
    params.require(:course).permit(:name, :desc, :cover_file_entity_id)
  end
end
