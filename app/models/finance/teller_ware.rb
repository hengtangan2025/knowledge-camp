class Finance::TellerWare < KcCourses::Ware
  KINDS = {
    day_begin_ops:                '日初处理',
    day_end_ops:                  '日终处理',

    saving_ops:                   '储蓄业务',
    personal_loan_ops:            '个人贷款业务',
    company_saving_and_loan_ops:  '对公存贷业务',
    delegate_ops:                 '代理业务',
    pay_and_settle_ops:           '支付结算',
    public_ops:                   '公共业务',
    stock_ops:                    '股金业务',
  }

  field :actions
  field :gtd_status
  field :number, type: String
  field :business_kind
  field :editor_memo
  field :desc

  validates :chapter, presence: false

  default_scope -> { asc(:number) }

  def business_kind_str
    kind = self.business_kind || ''
    KINDS[kind.to_sym]
  end
end