class RegistrationsController < Devise::SessionsController
  layout "new_version_base"
  skip_before_action :verify_authenticity_token, :only => :create, :if => :request_is_xhr
  def request_is_xhr
    request.xhr?
  end
  
  def new
    @page_name = 'sign_up'
    @component_data = {
      sign_in_url: sign_in_path,
      sign_up_url: sign_up_path,
      submit_url: api_sign_in_path
    }
    render :page
  end
  
end