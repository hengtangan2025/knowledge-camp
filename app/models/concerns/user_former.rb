module UserFormer
  extend ActiveSupport::Concern

  included do

    former "User" do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :email
      field :name
      field :created_at
      field :updated_at
      field :avatar, ->(instance){
        {
          url: "/assets/default_avatars/avatar_200.png",
          large:{ url: "/assets/default_avatars/large.png"},
          normal:{ url: "/assets/default_avatars/normal.png"},
          small:{ url: "/assets/default_avatars/small.png"}
        }
      }

    end

  end
end
