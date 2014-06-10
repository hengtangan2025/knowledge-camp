class SessionsController < Devise::SessionsController
  layout 'auth'

  def create
    return super if params[:format] != "json"

    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    render :json => current_user.info
  end
end