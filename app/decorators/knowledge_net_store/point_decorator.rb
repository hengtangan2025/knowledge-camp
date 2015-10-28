KnowledgeNetStore::Point.class_eval do
  include PinyinSearch
  pinyin :name

  has_and_belongs_to_many :tutorials,
                          :class_name => "KnowledgeNetPlanStore::Tutorial"

  has_and_belongs_to_many :virtual_files,
                          :class_name => 'VirtualFileSystem::File',
                          :inverse_of => :points

  def self.model_name
    ActiveModel::Name.new(KnowledgeNetStore::Point, nil, 'point')
  end
end
