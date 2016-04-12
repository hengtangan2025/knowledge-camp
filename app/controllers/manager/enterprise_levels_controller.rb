class Manager::EnterpriseLevelsController < Manager::ApplicationController
  def index
    @page_name = "manager_enterprise_levels"

    levels = EnterprisePositionLevel::Level.all.map do |level|
      DataFormer.new(level)
        .url(:delete_url)
        .url(:update_url)
        .data
    end

    @component_data = {
      levels: levels,
      create_url: manager_enterprise_levels_path
    }

    render "/mockup/page"
  end

  def create
    level = EnterprisePositionLevel::Level.new level_params
    save_model(level,"level") do |_level|
      DataFormer.new(_level)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def update
    level = EnterprisePositionLevel::Level.find params[:id]

    update_model(level, level_params, "level") do |_level|
      DataFormer.new(_level)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def destroy
    level = EnterprisePositionLevel::Level.find params[:id]
    level.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  private
  def level_params
    params.require(:level).permit(:name, :number)
  end
end
