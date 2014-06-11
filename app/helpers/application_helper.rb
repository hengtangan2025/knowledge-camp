module ApplicationHelper
  def page_title(title)
    content_for :page_title do
      title 
    end
  end

  def avatar(user, version = :normal)
    capture_haml {
      haml_tag 'div.-avatar-img', :class => version do
        haml_tag 'img', :src => user.avatar.versions[version].url
      end
    }
  end
end
