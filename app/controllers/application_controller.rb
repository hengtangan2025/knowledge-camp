require "cell/rails/helper_api" # cell helpers for simlpe_form, etc..

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 自定义登录后页面跳转
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
