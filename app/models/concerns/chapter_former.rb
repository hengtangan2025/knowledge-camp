module ChapterFormer
  extend ActiveSupport::Concern

  included do
    former "KcCourses::Chapter" do
      field :id, ->(instance) {instance.id.to_s}
      field :name

      url :update_url, ->(instance){
        manager_chapter_path(instance)
      }

      url :move_down_url, ->(instance){
        move_down_manager_chapter_path(instance)
      }

      url :move_up_url, ->(instance){
        move_up_manager_chapter_path(instance)
      }

      url :delete_url, ->(instance){
        manager_chapter_path(instance)
      }

      url :create_ware_url, ->(instance){
        manager_chapter_wares_path(instance)
      }

    end
  end
end
