module Finance::TellerWareScreenFormer
  extend ActiveSupport::Concern

  included do

    former 'Finance::TellerWareScreen' do
      field :id, ->(instance) {instance.id.to_s}
      field :hmdm
      field :zds
    end

  end
end