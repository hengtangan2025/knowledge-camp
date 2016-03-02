class Manage::AvatarsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find params[:user_id]
  end

  def update
    @user = User.find params[:user_id]
    data = params.require(:user).permit(:avatar)
    @user.update_attributes data
    redirect_to [:manage, @user, :avatar]
  end
end