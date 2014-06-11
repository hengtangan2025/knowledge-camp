class User
  include UserAuth::LocalStoreMode
  # carrierwave
  mount_uploader :avatar, AvatarUploader

  auth_field :login, 
    :login_validate => {
      :format => {
        :with => /\A[a-z0-9_]+\z/, 
        :message => '只允许数字、字母和下划线'
      }
    }

  def id
    attributes["_id"].to_s
  end

  def info
    {
      :id    => self.id,
      :name  => self.name,
      :login => self.login,
      :email => self.email
    }
  end
end