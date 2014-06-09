class User
  include UserAuth::LocalStoreMode

  def id
    attributes["_id"].to_s
  end
end