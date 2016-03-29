module Mockup::AuthMethods
  include SampleData

  def auth_page
    layout = 'mockup'

    @page_name = "auth_#{params[:page]}"
    case @page_name
      when 'auth_sign_in'
        get_auth_sign_in_data
      when 'auth_sign_up'
        get_auth_sign_up_data

      when 'auth_manager_sign_in'
        layout = 'mockup_manager_auth'
        get_auth_manager_sign_in_data
      end

    render layout: layout, template: 'mockup/page'
  end

  def get_auth_sign_in_data
    @component_data = {
      sign_in_url: mockup_auth_url(page: 'sign_in'),
      sign_up_url: mockup_auth_url(page: 'sign_up'),
      submit_url: mockup_auth_post_url(req: 'do_sign_in')
    }
  end

  def get_auth_sign_up_data
    @component_data = {
      sign_in_url: mockup_auth_url(page: 'sign_in'),
      sign_up_url: mockup_auth_url(page: 'sign_up'),
      submit_url: mockup_auth_post_url(req: 'do_sign_up')
    }
  end

  def get_auth_manager_sign_in_data
    @component_data = {
      submit_url: mockup_auth_post_url(req: 'do_sign_in'),
      manager_home_url: mockup_manager_url(page: 'home'),
    }
  end

  # --------------------

  def auth_do_post
    case params[:req]
      when 'do_sign_in' then post_do_sign_in
      when 'do_sign_up' then post_do_sign_up
      end
  end

  def post_do_sign_in
    if params[:user][:email].blank?
      data = { error: "用户名/密码不对" }
      render status: 401, json: data

    else
      render json: SAMPLE_USER_DATA
    end
  end

  def post_do_sign_up
    if params[:user][:name].blank?
      data = { errors: {
        email: ['邮箱没填'],
        password: ['密码没填', '密码太短'],
        name: ['啥都没填'],
      } }
      render status: 422, json: data

    else
      render json: SAMPLE_USER_DATA
    end
  end

  # ---------------
  def auth_do_delete
    render json: {}
  end

end