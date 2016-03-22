module Mockup::ManagerNotGetMethods
  include Mockup::SampleData
  
  def manager_do_post
    case params[:req]
      when 'create_course'
        post_create_course
      end
  end

  def post_create_course
    if params[:course][:name] == 'true'
      render json: {
        jump_url: mockup_manager_url(page: 'course_contents')
      }
    else
      render status: 422, json: {
        name: ['测试校验错误'],
        desc: ['测试校验错误']
      }
    end
  end
end