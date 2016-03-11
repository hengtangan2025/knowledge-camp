require "cell/rails/helper_api" # cell helpers for simlpe_form, etc..

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 自定义登录后页面跳转
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
  
  # 注册请求允许 user[:name]
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
    end
  
end
