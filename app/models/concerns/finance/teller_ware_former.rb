module Finance::TellerWareFormer
  extend ActiveSupport::Concern

  included do

    former 'Finance::TellerWare' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :number
      field :business_kind
      field :gtd_status

      logic :actions, ->(instance) {
        instance.actions
      }

      logic :business_kind_str, ->(instance) {
        instance.business_kind_str
      }

      url :preview_url, ->(instance){
        manager_finance_preview_path(number: instance.number)
      }
    end

  end
end