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
    end

  end
end