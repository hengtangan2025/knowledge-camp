module Mockup::ManagerMethods
  include Mockup::SampleData
  include ManagerNotGetMethods

  def manager_page
    @current_func = params[:page]
    @page_name = "manager_#{params[:page]}"
    case @page_name
      when 'manager_dashboard'
        get_manager_dashboard_data
      when 'manager_courses'
        get_manager_courses_data
      when 'manager_new_course'
        get_manager_new_course_data
      when 'manager_course_contents'
        get_manager_course_contents_data
      end

    render layout: 'mockup_manager', template: 'mockup/page'
  end

  def get_manager_dashboard_data
    # nothing
  end

  def get_manager_courses_data
    courses = 
      if params[:empty]
      then []
      else SAMPLE_COURSES_DATA.map { |x|
        x[:manager_contents_url] = mockup_manager_url('course_contents')
        x
      }
      end

    @component_data = {
      new_course_url: mockup_manager_url(page: 'new_course'),
      courses: courses,
      paginate: SAMPLE_PAGINATE_DATA,
      # 用于生成顶部过滤
      filter_subjects: [ 
        {name: '电子商务', id: '1'},
        {name: '农产品销售', id: '2'},
      ],
    }
  end

  def get_manager_new_course_data
    @component_data = {
      create_course_url: mockup_manager_post_url(req: 'create_course')
    }
  end

  def get_manager_course_contents_data
    @component_data = {
      course: SAMPLE_COURSE_DATA,
      manager_courses_url: mockup_manager_url(page: 'courses'),
      manager_create_chapter_url: mockup_manager_post_url(req: 'create_chapter')
    }
  end
end