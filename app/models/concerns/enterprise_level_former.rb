module EnterpriseLevelFormer
  extend ActiveSupport::Concern

  included do

    former 'EnterprisePositionLevel::Level' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :number

      url :delete_url, ->(instance){
        manager_enterprise_level_path(instance)
      }

      url :update_url, ->(instance){
        manager_enterprise_level_path(instance)
      }

    end

  end
end
