class IndexController < ActionController::Base
  before_filter :authenticate_user!

  def index
    redirect_to [:bank, :manage, :courses], :status => 301
  end
end
