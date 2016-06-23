module FileEntityFormer
  extend ActiveSupport::Concern

  included do

    former "FilePartUpload::FileEntity" do
      field :id, ->(instance) {instance.id.to_s}
      field :original
      field :meta
      field :url
    end

  end
end