module NoteFormer
  extend ActiveSupport::Concern

  included do
    former "NoteMod::Note" do
      field :id, ->(instance) {instance.id.to_s}
      field :title
      field :content
      field :creator, ->(instance) {
        DataFormer.new(instance.creator).data
      }
      field :created_at
      field :updated_at

      logic :targetable, ->(instance) {
        case instance.targetable
        when Finance::TellerWare
          return {
            name: instance.targetable.name,
            url: manager_finance_preview_path(number: instance.targetable.number)
          }
        else
          return nil
        end
      }
    end

  end
end
