class Manager::DashboardController < Manager::ApplicationController
  include ApplicationHelper

  def index
    @page_name = "manager_dashboard"
    @component_data = {
      scenes: manager_sidebar_scenes
    }
    render "/mockup/page"
  end
end
