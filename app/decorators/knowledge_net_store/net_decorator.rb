KnowledgeNetStore::Net.class_eval do
  include Kaminari::MongoidExtension::Document

  has_many :documents,
           :class_name => 'DocumentsStore::Document',
           :dependent => :destroy

  has_many :plans,
           :class_name => 'KnowledgeNetPlanStore::Plan',
           :dependent => :destroy

  has_many :virtual_files,
           :class_name => 'VirtualFileSystem::File',
           :dependent => :destroy

  after_create :create_default_plan

  def default_plan
    create_default_plan if plans.blank?
    plans.first
  end

  def topics
    default_plan.topics
  end

  def self.model_name
    ActiveModel::Name.new(KnowledgeNetStore::Net, nil, 'net')
  end

  private

  def create_default_plan
    self.plans.create :title => "default_plan"
  end
end
