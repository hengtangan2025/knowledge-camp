class Manager::DashboardController < ApplicationController
  layout "new_version_manager"
  def index
    @page_name = "manager_dashboard"
    render :page
  end
end
