class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  field :name, type: String
  
  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  
  # carrierwave
  mount_uploader :avatar, AvatarUploader

  def id
    attributes["_id"].to_s
  end

  def info
    {
      :id    => self.id,
      :name  => self.name,
      :login => self.login,
      :email => self.email,
      :avatar => self.avatar.url
    }
  end

  include KnowledgeCamp::Step::NoteCreator
  include KnowledgeCamp::Step::QuestionCreator
  include KnowledgeCamp::Step::SelectionCreator
  include KnowledgeCamp::HasManyLearnRecords
  include TutorialLearnProgress::UserMethods
  include TopicLearnProgress::UserMethods


  has_many :virtual_files,
           :class_name => "VirtualFileSystem::File",
           :foreign_key => :creator_id,
           :dependent => :destroy

  has_many :tutorials,
           :class_name => KnowledgeNetPlanStore::Tutorial.name,
           :foreign_key => :creator_id,
           :dependent => :destroy
end
