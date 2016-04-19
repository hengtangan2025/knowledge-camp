class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 自定义登录后页面跳转
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def save_model(model, wrap = nil, &block)
    if model.save
      data = block.call(model)
      data = {wrap.to_sym => data} if !wrap.blank?
      render json: data
    else
      data = model.errors.messages
      data = {wrap.to_sym => data} if !wrap.blank?
      render json: data, :status => 422
    end
  end

  def update_model(model, params_attrs, wrap = nil, &block)
    if model.update_attributes params_attrs
      data = block.call(model)
      data = {wrap.to_sym => data} if !wrap.blank?
      render json: data
    else
      data = model.errors.messages
      data = {wrap.to_sym => data} if !wrap.blank?
      render json: data, :status => 422
    end
  end

  # 注册请求允许 user[:name]
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
    end

end
