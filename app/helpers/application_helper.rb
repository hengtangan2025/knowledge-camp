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

  # 比较不同文档之间的差异，返回添加了差异标记的 html 文本
  # 参考：http://www.rohland.co.za/index.php/2009/10/31/csharp-html-diff-algorithm/
  # 使用了：https://github.com/myobie/htmldiff
  # 这里的 version_obj 是对象，不是编号
  def show_document_version_change(document, version_obj)
    if version_obj.version == 1
      return {
        :title => MindpinHTMLDiff.diff('', version_obj.title).html_safe,
        :content => MindpinHTMLDiff.diff('', version_obj.content).html_safe
      }
    end

    prev_version_obj = 
      document.versions.unscoped.where(:version.lt => version_obj.version).last

    return {
      :title => MindpinHTMLDiff.diff(prev_version_obj.title, version_obj.title).html_safe,
      :content => MindpinHTMLDiff.diff(prev_version_obj.content, version_obj.content).html_safe
    }
  end
end
