module BusinessCategoryFormer
  extend ActiveSupport::Concern

  included do

    former 'Bank::BusinessCategory' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :number
      field :parent_id, ->(instance) {
        parent_id = instance.parent_id
        parent_id ? parent_id.to_s : nil
      }

      url :delete_url, ->(instance){
        manager_business_category_path(instance)
      }

      url :update_url, ->(instance){
        manager_business_category_path(instance)
      }

    end

  end
end
