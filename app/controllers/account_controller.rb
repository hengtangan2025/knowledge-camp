class AccountController < ApplicationController
  before_filter :authenticate_user!
  
  def avatar
  end

  def avatar_update
    current_user.avatar = params[:user][:avatar]
    current_user.save
    redirect_to :action => :avatar
  end
end