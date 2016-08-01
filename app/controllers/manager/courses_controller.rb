class Manager::CoursesController < Manager::ApplicationController

  def index
    @page_name = "manager_courses"
    courses = KcCourses::Course.all.page(params[:page])
    data    = combine_course_data(courses)
    subjects_data = combine_course_subject_data()

    @component_data = extract_data(courses, data, subjects_data)

    render "/mockup/page"
  end

  # 查询根据课程分类下拉菜单中的 "全部课程" 查询所有的课程
  def select_all_of_corse
    courses = KcCourses::Course.all.page(params[:page])
    data    = combine_course_data(courses)
    subjects_data = combine_course_subject_data()
    all_of_course_data = extract_data(courses, data, subjects_data)
    
    render json: all_of_course_data
  end


  # 进行分类查询
  def select_courses_from_subject
    course_subject_id = params[:subject_id]

    courses = KcCourses::Course.where(:course_subject_ids.in => [course_subject_id]).page(params[:page])
    data = combine_course_data(courses)
    subjects_data = combine_course_subject_data()

    data = extract_data(courses, data, subjects_data)

    render json: data
  end

  def edit_subject
    @page_name = "manager_edit_subject"

    course = KcCourses::Course.find(params[:id])
    data =  DataFormer.new(course)
        .logic(:published)
        .url(:publish_url, :publish_url, course_id: course.id.to_s)
        .url(:recall_url,  :recall_url,  course_id: course.id.to_s)
        .data 

    @component_data = {
      subjects: KcCourses::CourseSubject.all,
      course_id: params[:id],
      self_subjects_ids: KcCourses::Course.find(params[:id]).course_subject_ids,
      published: data[:published],
      publish_url: data[:publish_url],
      recall_url: data[:recall_url]
    }
    render "/mockup/page"
  end
   
  def update_subject
    course = KcCourses::Course.find(params[:id])
    course.course_subject_ids = params[:subjects_ids]
    if course.save
      render :text => "保存成功"
    end
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
      .logic(:published)
      .url(:publish_url, :publish_url, course_id: course.id.to_s)
      .url(:recall_url,  :recall_url,  course_id: course.id.to_s)
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

    # 组织课程、课程分类数据
    def extract_data(courses, data, subjects_data)
      need_data = {
        new_course_url: new_manager_course_path,
        courses: data,
        paginate: {
          total_pages: courses.total_pages,
          current_page: courses.current_page,
          per_page: courses.limit_value
        },
        # 用于生成顶部过滤
        filter_subjects: subjects_data, 
      }
      need_data
    end

    # 找出所有课程分类并重新组织数据
    def combine_course_subject_data
      subjects = KcCourses::CourseSubject.all
      items = subjects.map do |_cs|
        DataFormer.new(_cs)
          .url(:update_url)
          .url(:delete_url)
          .url(:search_courses_url)
          .data
      end
      items
    end
   
    def combine_course_data(courses)
      data = courses.map do |course|
        DataFormer.new(course)
          .logic(:instructor)
          .url(:manager_contents_url).data
      end
      data
    end
end
