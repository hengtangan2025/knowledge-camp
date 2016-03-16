class IndexController < ApplicationController
  layout "new_version_base"

  def index
    @page_name = "home"
    @component_data = {
      manager_sign_in_url: sign_in_path(role: "manager")
    }
    render :page
  end
end
