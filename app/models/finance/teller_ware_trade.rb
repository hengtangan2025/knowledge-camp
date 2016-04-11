class Finance::TellerWareTrade
  include Mongoid::Document

  field :number # 业务代码
  field :jydm   # 业务关联交易代码
  field :jymc   # 交易名称
  field :xh     # 交易序号
  field :input_screen_hmdms # 输入画面代码（多个）
  field :response_screen_hmdm # 响应画面代码（一个）
  field :compound_screen_hmdm # 结算画面代码（一个）

  default_scope -> { order_by(number: :asc, xh: :asc) }
end