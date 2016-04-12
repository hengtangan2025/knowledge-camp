class Manager::DashboardController < Manager::ApplicationController

  def index
    @page_name = "manager_dashboard"
    render "/mockup/page"
  end
end
