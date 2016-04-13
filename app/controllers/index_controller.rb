class IndexController < ApplicationController
  layout "new_version_base"

  def index
    @page_name = "home"

    user_data = 
      if current_user.present?
      then DataFormer.new(current_user).data
      else nil
      end 

    @component_data = {
      manager_url: manager_dashboard_path,
      manager_sign_in_url: sign_in_path(role: "manager"),
      current_user: user_data
    }
    render :page
  end
end
