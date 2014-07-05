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

    haml_tag "div.bread.#{name}" do
      haml_tag "div.bread-link" do
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

  # 根据字符串的 md5 生成颜色值，用于排版方法
  def string_md5_color(str)
    "##{Digest::MD5.hexdigest(str)[0...6]}"
  end

  class ColorTransfer
    include Sass::Script

    def self.parse_color(s)
      r = s[1..2].to_i(16)
      g = s[3..4].to_i(16)
      b = s[5..6].to_i(16)

      c = Color.new [r, g, b]
      c.options = {}
      return c
    end

    def self.mix(s1, s2, i3)
      c1 = parse_color(s1)
      c2 = parse_color(s2)
      weight = Number.new(i3)

      c = Functions::EvaluationContext.new({}).mix(c1, c2, weight)
      c.options = {}
      return c
    end

    def self.invert(c1)
      c = Functions::EvaluationContext.new({}).invert(c1)
      c.options = {}
      return c
    end

    def self.grayscale(c1)
      c = Functions::EvaluationContext.new({}).grayscale(c1)
      c.options = {}
      return c
    end

    def self.darken(s1)
      c1 = parse_color(s1)

      amount = Number.new(10)
      c = Functions::EvaluationContext.new({}).darken(c1, amount)
      c.options = {}
      return c
    end
  end

  # 根据字符串生成适合 grid 显示的 颜色值
  def string_grid_color(str)
    colors = 
      %w(
        #1ABC9C #2ECC71 #3498DB #9B59B6 
        #34495E #F1C40F #E67E22 #E74C3C 
        #95A5A6
      )

    # 颜色来自 http://flatuicolors.com/

    md5 = Digest::MD5.hexdigest(str)
    i1 = md5[0..1].to_i(16) % colors.length
    i2 = md5[2..3].to_i(16) % colors.length
    i3 = md5[4..5].to_i(16) % 100

    c1 = colors[i1]
    c2 = colors[i2]

    bgc = ColorTransfer.mix(c1, c2, i3)
    # ColorTransfer.darken bgc.to_s
  end
end
