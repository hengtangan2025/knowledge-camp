class MockupController < ApplicationController
  include Mockup::AuthMethods
  include Mockup::ManagerMethods
  include Mockup::FrontendMethods

  def page
    layout = 'mockup'

    @page_name = params[:page]
    case @page_name
      when 'home'
        get_home_data
      when 'courses'
        get_courses_data
      when 'course_show'
        get_course_show_data
      when 'ware_show'
        layout = 'mockup_course_ware'
        get_ware_show_data
      end

    render layout: layout
  end

  def get_home_data
    @component_data = {
      manager_sign_in_url: mockup_auth_url(page: 'manager_sign_in')
    }
  end

  def get_courses_data
    @component_data = {
      courses: SAMPLE_COURSES_DATA,
      paginate: SAMPLE_PAGINATE_DATA
    }
  end

  def get_course_show_data
    @component_data = SAMPLE_COURSE_DATA
  end

  def get_ware_show_data
    @component_data = {
      comments: SAMPLE_COMMENTS_DATA,
      course: SAMPLE_COURSE_DATA,
      ware: SAMPLE_WARES_DATA.select {|x| x[:id] == params[:id]}.first
    }
  end

  # -----------------------

  def do_post
    case params[:req]
      when 'create_file_entity'
        post_create_file_entity
      end
  end

  def post_create_file_entity
    render json: { id: 'id_12345678' }
  end
end