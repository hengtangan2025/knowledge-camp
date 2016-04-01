class SessionsController < Devise::SessionsController
  layout "new_version_base"
  skip_before_action :verify_authenticity_token, :only => :create, :if => :request_is_xhr
  def request_is_xhr
    request.xhr?
  end

  def new
    if params[:role] == "manager"
      @page_name = 'auth_manager_sign_in'
      @component_data = {
        submit_url: api_sign_in_path,
        manager_home_url: manager_dashboard_path
      }
      return render :page, layout: "mockup_manager_auth"
    end

    @page_name = 'auth_sign_in'
    @component_data = {
      sign_in_url: sign_in_path,
      sign_up_url: sign_up_path,
      submit_url: api_sign_in_path
    }
    render "/mockup/page"
  end
end