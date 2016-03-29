class DataFormer
  include DataFormerConfig

  former 'KcCourses::Course' do
    brief do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :desc
    end

    logics do
      logic :learned, ->(instance, user){
        percent = instance.read_percent_of_user(user)
        learned = 'done' if percent == 100
        learned = 'half' if percent > 0 && percent < 100
        learned = 'no'   if percent == 0
        learned
      }
    end

    urls do
      url :update, ->(instance, controller){
        controller.course_path(instance)
      }
    end

  end
end
