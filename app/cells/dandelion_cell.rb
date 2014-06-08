class DandelionCell < Cell::Rails
  helper :dandelion

  EMPTY_FLAG = :_EMPTY
  OPS_KEY = :_OPS

  LIST_CONFIG = {
    :manage => {
      :net => {
        :name => -> (model) {
            capture_haml {
              haml_tag 'a', model.name, :href => url_for([:manage, model])
            }
          },
        :desc => -> (model) {
            return EMPTY_FLAG if model.desc.blank?
            model.desc
          },
        :updated_at => true
      }
    },

    plan: {
      name: -> (model) {
          capture_haml {
            haml_tag 'i.fa.fa-list-ul'
            haml_tag 'a', model.name, :href => url_for([model])
          }
        },
      belongs_to_net: -> (model) {
          capture_haml {
            haml_tag 'i.fa.fa-tree'
            haml_tag 'span', '所属知识网络：'
            haml_tag 'a', model.net.name, :href => url_for([model.net])
          }
        },
      desc: -> (model) {
          return EMPTY_FLAG if model.desc.blank?
          simple_format model.desc
        },
      :updated_at => true,
      OPS_KEY => {
        :edit => true,
        :delete => true
      }
    }
  }


  def new_button(option)
    @parents = option[:parents]
    @klass   = option[:klass]

    # @url   = File.join "/", @model.model_name.route_key, 'new'
    @url   = url_for [:new] + @parents + [@klass.model_name.name]
    @text  = "新建#{@klass.model_name.human}" 
    render
  end

  def form(option)
    @parents = option[:parents]
    @model   = option[:model]

    @form_for = @parents + [@model]
    @cancel_url = option[:cancel_url] || 'javascript:history.go(-1)'

    if @model.new_record?
      @h2  = "新建#{@model.model_name.human} …"
    else
      @h2  = "编辑#{@model.model_name.human} …"
    end

    render
  end

  def list(option)
    @klass      = option[:klass]
    @models     = option[:models] || @klass.all.order_by("updated_at DESC")
    @namespace  = option[:namespace]

    @plural   = @klass.model_name.plural # 列表 css class
    @singular = @klass.model_name.singular # 列表项 css class
    @config =
      if @namespace && LIST_CONFIG[@namespace]
        LIST_CONFIG[:manage][@singular.to_sym]
      else
        LIST_CONFIG[@singular.to_sym]
      end

    render
  end
end