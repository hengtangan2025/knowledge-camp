class Finance::TellerWareScreen
  include Mongoid::Document

  field :hmdm # 画面代码
  field :zds # 字段数据

  field :sample_data # 示例数据

  default_scope -> { order_by(hmdm: :asc) }
end