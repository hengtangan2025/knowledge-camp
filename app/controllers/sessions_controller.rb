class SessionsController < Devise::SessionsController
  layout "new_version_base"
  skip_before_action :verify_authenticity_token, :only => :create, :if => :request_is_xhr
  def request_is_xhr
    request.xhr?
  end

  def new
    case params[:role]
    when 'manager'
      manager_sign_in
    else
      common_user_bank_sign_in
    end
  end

  private 
  def common_user_sign_in
    @page_name = 'auth_sign_in'
    @component_data = {
      sign_in_url: sign_in_path,
      sign_up_url: sign_up_path,
      submit_url: api_sign_in_path
    }
    render "/mockup/page"
  end

  def manager_sign_in
    @page_name = 'auth_manager_sign_in'
    @component_data = {
      common_sign_in_url: sign_in_path,

      submit_url: api_sign_in_path,
      manager_home_url: manager_dashboard_path
    }
    render "/mockup/page", layout: "mockup_manager_auth"
  end

  def common_user_bank_sign_in
    @page_name = 'auth_bank_sign_in'
    @component_data = {
      sign_in_url: sign_in_path,
      manager_sign_in_url: sign_in_path(role: 'manager'),

      sign_up_url: sign_up_path,
      submit_url: api_sign_in_path,
    }
    render "/mockup/page", layout: 'mockup_bank_auth'
  end
end