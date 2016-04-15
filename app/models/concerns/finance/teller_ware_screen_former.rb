module Finance::TellerWareScreenFormer
  extend ActiveSupport::Concern

  included do

    former 'Finance::TellerWareScreen' do
      field :id, ->(instance) {instance.id.to_s}
      field :hmdm
      field :zds
    end

    former 'Finance::TellerWareXxmx' do
      field :id, ->(instance) {instance.id.to_s}
      field :xxdm
      field :xxqz
      field :xxmc
      field :xxzb
    end

    former 'Finance::TellerWareMediaClip' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :desc
      field :file_entity_id, ->(instance) {instance.file_entity_id.to_s}
      field :created_at
      field :updated_at
      field :cid

      logic :file_info, ->(instance) {
        # kind: [:image, :video, :other],
        {
          kind: instance.file_entity.kind,
          url: instance.file_entity.url
        }
      }

      url :update_url, ->(instance) {
        manager_finance_teller_ware_media_clip_path(instance)
      }
    end

  end
end