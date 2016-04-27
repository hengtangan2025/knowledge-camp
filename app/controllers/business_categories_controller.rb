class BusinessCategoriesController < ApplicationController
  layout "new_version_base"

  def index
    @page_name = "front_business_categories"

    if params[:pid].blank?
      parents_data = []
      data = Bank::BusinessCategory.where(depth: 1).map {|x|
        DataFormer.new(x).logic(:is_leaf).data
      }
    else
      parent_bc = Bank::BusinessCategory.find params[:pid]
      data = parent_bc.children.map {|x|
        DataFormer.new(x).logic(:is_leaf).data
      }
      parent_ids = parent_bc.parent_ids + [parent_bc.id]
      parent_ids.shift
      parents_data = parent_ids.map {|id|
        c = Bank::BusinessCategory.find id

        {
          category: DataFormer.new(c).data,
          siblings: c.parent.children.map {|x|
            DataFormer.new(x).data
          }
        }
      }
    end

    @component_data = {
      parents_data: parents_data,
      categories: data
    }
  end

  def show
    bc = Bank::BusinessCategory.find params[:id]
    parent_ids = bc.parent_ids
    parent_ids.shift

    @page_name = "front_business_category_show"
    @component_data = {
      parents_data: parent_ids.map {|id|
        c = Bank::BusinessCategory.find id
        DataFormer.new(c).data
      },
      category: DataFormer.new(bc).data
    }
  end
end