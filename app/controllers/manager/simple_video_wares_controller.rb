class Manager::SimpleVideoWaresController < Manager::ApplicationController
  def index
    @page_name = "manager_simple_video_wares"

    wares      = KcCourses::SimpleVideoWare.all.page(params[:page])
    wares_data = wares.map do |ware|
      DataFormer.new(ware)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
    end

    @component_data = {
      new_simple_video_wares_url: new_manager_simple_video_ware_path,
      simple_video_wares: wares_data,
      paginate: {
        total_pages: wares.total_pages,
        current_page: wares.current_page,
        per_page: wares.limit_value
      }
    }
  end

  def new
    @page_name = "manager_new_simple_video_ware"
    @component_data = {
      create_simple_video_ware_url: manager_simple_video_wares_path
    }
  end

  def create
    ware = KcCourses::SimpleVideoWare.new simple_video_ware_params
    ware.creator = current_user

    save_model(ware) do |c|
      DataFormer.new(c)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
        .merge jump_url: edit_business_categories_manager_simple_video_ware_path(c)
    end
  end

  def edit
    ware = KcCourses::SimpleVideoWare.find params[:id]

    @page_name = "manager_edit_simple_video_ware"
    @component_data = {
      simple_video_ware: ware,
      update_base_info_url: manager_simple_video_ware_path(ware)
    }
  end

  def update
    ware = KcCourses::SimpleVideoWare.find params[:id]

    update_model(ware, update_simple_video_ware_params) do |c|
      DataFormer.new(c)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
        .merge jump_url: manager_simple_video_wares_path
    end
  end

  def edit_business_categories
    ware = KcCourses::SimpleVideoWare.find params[:id]

    business_categories = Bank::BusinessCategory.all.map do |bc|
      DataFormer.new(bc).data
    end

    @page_name = "manager_edit_business_categories_simple_video_ware"
    @component_data = {
      simple_video_ware: DataFormer.new(ware).data,
      business_categories: business_categories,
      update_business_categories_url: update_business_categories_manager_simple_video_ware_path(ware)
    }
  end

  def update_business_categories
    ware = KcCourses::SimpleVideoWare.find params[:id]

    update_model(ware, update_business_categories_simple_video_ware_params) do |c|
      DataFormer.new(c)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
        .merge jump_url: manager_simple_video_wares_path
    end
  end

  private
  def simple_video_ware_params
    params.require(:simple_video_wares).permit(:name, :desc, :file_entity_id, business_category_ids: [])
  end

  def update_simple_video_ware_params
    params.require(:simple_video_wares).permit(:name, :desc)
  end

  def update_business_categories_simple_video_ware_params
    params.require(:simple_video_wares).permit(business_category_ids: [])
  end
end
