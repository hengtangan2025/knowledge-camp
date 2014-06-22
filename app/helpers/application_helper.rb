module ApplicationHelper
  # 网页标题
  def page_title(title)
    content_for :page_title do
      title 
    end
  end

  # 头像
  def avatar(user, version = :normal)
    capture_haml {
      haml_tag 'div.-avatar-img', :class => version do
        haml_tag 'img', :src => user.avatar.versions[version].url
      end
    }
  end

  # 层叠式面包屑
  def bread(data, toggle = ['open', 'close'], &block)
    mb = data.length * 29

    capture_haml {
      haml_tag 'div.page-bread-pieces', :style => "margin-bottom:#{mb}px" do
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

  # 友好的文件大小表示
  def human_file_size(bytes)
    return "#{bytes}B" if bytes < 1024
    return "#{(bytes / 1024.0).round}KB" if bytes < 1048576
    return "#{(bytes / 1048576.0).round}MB"
  end
end
