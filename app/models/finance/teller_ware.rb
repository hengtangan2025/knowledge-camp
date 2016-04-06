class Finance::TellerWare < KcCourses::Ware
  field :actions
  field :gtd_status
  field :number
  field :business_kind

  validates :chapter, presence: false
end