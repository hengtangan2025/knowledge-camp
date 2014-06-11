module ApplicationHelper
  def page_title(title)
    content_for :page_title do
      title 
    end
  end

  def avatar(user)
    capture_haml {
      haml_tag 'div.-avatar-img' do
        haml_tag 'img', :src => '/assets/default_avatars/avatar_200.png'
      end
    }
  end
end
