class IndexController < ActionController::Base
  before_filter :authenticate_user!

  def index
    redirect_to [:old, :manage, KnowledgeNetStore::Net], :status => 301
  end
end
