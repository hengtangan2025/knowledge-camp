class User
  include UserAuth::LocalStoreMode

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
end