class Manager::BusinessCategoriesController < Manager::ApplicationController
  def index
    @page_name = "manager_business_categories"

    business_categories = Bank::BusinessCategory.all.map do |bc|
      DataFormer.new(bc)
        .url(:update_url)
        .url(:delete_url)
        .data
    end

    @component_data = {
      business_categories: business_categories,
      create_business_category_url: manager_business_categories_path
    }
    render "mockup/page"
  end

  def create
    bc = Bank::BusinessCategory.new business_category_params
    save_model(bc) do |_bc|
      DataFormer.new(_bc)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def update
    bc = Bank::BusinessCategory.find params[:id]

    update_model(bc, business_category_params) do |_bc|
      DataFormer.new(_bc)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def destroy
    bc = Bank::BusinessCategory.find params[:id]
    bc.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  private

  def business_category_params
    params.require(:business_category).permit(:name, :number, :parent_id)
  end

end
