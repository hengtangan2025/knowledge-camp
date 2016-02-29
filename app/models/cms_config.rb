class CmsConfig
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :value

  validates :name, presence: true
end
