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
      when 'manager_courses_publish'
        get_manager_courses_publish_data

      when 'manager_csubjects'
        get_manager_csubjects_data

      when 'manager_questions'
        get_manager_questions_data
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
    data = SAMPLE_COURSE_DATA.clone
    data[:chapters].each do |c|
      c[:create_ware_url] = mockup_manager_post_url(req: 'create_ware')
      c[:update_url] = mockup_manager_put_url(req: 'common')
      c[:move_up_url] = mockup_manager_put_url(req: 'common')
      c[:move_down_url] = mockup_manager_put_url(req: 'common')
      c[:delete_url] = mockup_manager_delete_url(req: 'common')
      c[:wares].each do |w|
        w[:update_url] = mockup_manager_put_url(req: 'common')
        w[:move_up_url] = mockup_manager_put_url(req: 'common')
        w[:move_down_url] = mockup_manager_put_url(req: 'common')
        w[:delete_url] = mockup_manager_delete_url(req: 'common')
      end
    end

    @component_data = {
      course: data,
      manager_courses_url: mockup_manager_url(page: 'courses'),
      manager_create_chapter_url: mockup_manager_post_url(req: 'create_chapter')
    }
  end

  def get_manager_csubjects_data
    subjects = 
      if params[:empty]
      then []
      else SAMPLE_CSUBJECTS_DATA
      end

    subjects.each { |s|
      s[:delete_url] = mockup_manager_delete_url(req: 'common')
      s[:update_url] = mockup_manager_post_url(req: 'common')
    }

    @component_data = {
      subjects: subjects,
      create_subject_url: mockup_manager_post_url(req: 'create_subject'),
    }
  end

  def get_manager_courses_publish_data
    if params[:empty]
      @component_data = {
        prepared_courses: [],
        paginate: nil
      }
    else
      @component_data = {
        prepared_courses: SAMPLE_COURSES_DATA.map { |x|
          x.merge(
            publish_url: mockup_manager_post_url(req: 'common'),
            published: false
          )
        },
        paginate: SAMPLE_PAGINATE_DATA
      }
    end
  end

  def get_manager_questions_data
    @component_data = {
      questions: SAMPLE_QUESTIONS_DATA
    }
  end
end