module Finance::TellerWareScreenFormer
  extend ActiveSupport::Concern

  included do

    former 'Finance::TellerWareScreen' do
      field :id, ->(instance) {instance.id.to_s}
      field :hmdm
      field :zds
    end

    former 'Finance::TellerWareXxmx' do
      field :id, ->(instance) {instance.id.to_s}
      field :xxdm
      field :xxqz
      field :xxmc
      field :xxzb
    end

  end
end