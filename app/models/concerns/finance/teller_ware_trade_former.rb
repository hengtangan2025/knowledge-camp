module Finance::TellerWareTradeFormer
  extend ActiveSupport::Concern

  included do

    former 'Finance::TellerWareTrade' do
      field :id, ->(instance) {instance.id.to_s}
      field :number
      field :jydm
      field :jymc
      field :xh
      field :input_screen_hmdms
      field :response_screen_hmdm
      field :compound_screen_hmdm

      logic :all_hmdms, ->(instance) {
        [
          instance.input_screen_hmdms,
          instance.response_screen_hmdm,
          instance.compound_screen_hmdm
        ].flatten.compact.uniq 
      }
    end

  end
end