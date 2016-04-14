module Finance::TellerWareFormer
  extend ActiveSupport::Concern

  included do

    former 'Finance::TellerWare' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :number
      field :business_kind
      field :gtd_status
      field :editor_memo
      field :desc

      logic :actions, ->(instance) {
        instance.actions
      }

      logic :business_kind_str, ->(instance) {
        instance.business_kind_str
      }

      url :preview_url, ->(instance) {
        manager_finance_preview_path(number: instance.number)
      }

      url :design_url, ->(instance) {
        design_manager_finance_teller_ware_path instance
      }

      url :update_url, ->(instance) {
        manager_finance_teller_ware_path instance
      }

      url :design_update_url, ->(instance) {
        design_update_manager_finance_teller_ware_path instance
      }
    end

  end
end