module DandelionHelper
  def dendelion_new_button(klass)
    render_cell :dandelion, :new_button, :model => klass.new
  end

  def dendelion_list_field(model, key, cfg)
    return if key == DandelionCell::OPS_KEY

    value = case cfg
      when true
        model[key]
      when Proc
        self.instance_exec model, &cfg
      else
        model[key]
      end

    return if value == DandelionCell::EMPTY_FLAG

    case value
      when Time
        capture_haml {
          haml_tag "div.field.-time.#{key}", value.to_s(:db), :data => {:time => value.to_i * 1000}
        }
      else
        capture_haml {
          haml_tag "div.field.#{key}", value
        }
      end
  end

  def dendelion_list_button(model, key, cfg = [])
    return _dendelion_list_edit_button(model) if key == :edit
    return _dandelion_list_delete_button(model) if key == :delete

    color  = "btn-bdb-#{cfg[0]}"
    icon   = "fa-#{cfg[1]}"
    text   = cfg[2]
    title  = cfg[3] || ''

    capture_haml {
      haml_tag "a.#{key}.btn.btn-rounded.btn-small.#{color}", 
        :href => url_for([key, model]),
        :title => title do
          haml_tag "i.fa.#{icon}"
          haml_tag "span", text
      end
    }
  end

  def _dendelion_list_edit_button(model)
    capture_haml {
      haml_tag 'a.edit.btn.btn-rounded.btn-bdb-info.btn-small',
        :href => url_for([:edit, model]),
        :title => '编辑' do
          haml_tag "i.fa.fa-pencil"
          haml_tag "span", '编辑'
      end
    }
  end

  def _dandelion_list_delete_button(model)
    capture_haml {
      haml_tag 'a.delete.btn.btn-rounded.btn-bdb-danger.btn-small',
        :href => url_for([model]),
        :data => {:method => :delete, :confirm => "确定要删除吗？"},
        :title => '删除' do
          haml_tag "i.fa.fa-trash-o"
          haml_tag "span", '删除'
      end
    }
  end

end