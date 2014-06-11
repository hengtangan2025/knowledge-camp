class SessionsController < Devise::SessionsController
  layout 'auth'
  skip_before_action :verify_authenticity_token, :only => :create, :if => :format_is_json
  def format_is_json
    "json" == params[:format]
  end

  def create
    return super if params[:format] != "json"

    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    render :json => current_user.info
  end
end