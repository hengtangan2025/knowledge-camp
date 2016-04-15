class Finance::TellerWareMediaClip
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :file_entity, class_name: 'FilePartUpload::FileEntity'
  validates :file_entity_id, presence: true

  has_many :teller_ware, class_name: 'Finance::TellerWare'

  field :name
  field :desc
end