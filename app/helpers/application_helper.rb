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

  def bread(data, toggle = ['open', 'close'], &block)
    capture_haml {
      haml_tag 'div.page-bread-pieces' do
        _bread(data, 0, toggle, &block)
      end
    }
  end

  def _bread(data, index, toggle, &block)
    name, text, url = data[index]

    haml_tag 'div.bread' do
      haml_tag "div.link.#{name}" do
        haml_tag 'a', text, :href => url, :data => {:toggle => toggle}
      end

      if index < data.length - 1
        _bread(data, index + 1, toggle, &block)
      else
        haml_tag 'div.bread.current' do
          yield
        end
      end
    end
  end

end
