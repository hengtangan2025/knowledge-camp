class Finance::TellerWareXxmx
  include Mongoid::Document

  field :xxdm # 选项代码
  field :xxqz # 选项取值
  field :xxmc # 选项名称
  field :xxzb # 选项组别

  default_scope -> { order_by(xxqz: :asc) }
end