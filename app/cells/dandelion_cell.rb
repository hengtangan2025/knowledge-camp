class DandelionCell < Cell::Rails
  helper :dandelion

  EMPTY_FLAG = :_EMPTY
  OPS_KEY = :_OPS

  LIST_CONFIG = {
    :net => {
      :name => -> (model) {
          capture_haml {
            haml_tag 'i.fa.fa-tree'
            haml_tag 'a', model.name, :href => url_for([model])
          }
        },
      :desc => -> (model) {
          return EMPTY_FLAG if model.desc.blank?
          simple_format model.desc
        },
      :point_count => -> (model) {
          capture_haml {
            haml_tag 'span', '知识节点数目：'
            haml_tag 'span', model.points.count
          }
        },
      :updated_at => true,
      OPS_KEY => {
        :graph => [:info, :sitemap, '展示', '可视化展现'],
        :edit => true,
        :delete => true
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
    @model = option[:model]
    @url   = File.join "/", @model.model_name.route_key, 'new'
    @text  = "新建#{@model.model_name.human}" 
    render
  end

  def form(option)
    @model      = option[:model]
    @cancel_url = File.join "/", @model.model_name.route_key

    if @model.new_record?
      @h2  = "新建#{@model.model_name.human} …"
    else
      @h2  = "编辑#{@model.model_name.human} …"
    end

    render
  end

  def list(option)
    @klass    = option[:klass]
    @models   = @klass.all.order_by("updated_at DESC")
    @plural   = @klass.model_name.plural
    @singular = @klass.model_name.singular

    # @keys     = @klass.fields.keys
    # TODO 需要有自行配置显示哪些字段和如何显示的方法

    @config = LIST_CONFIG[@singular.to_sym]

    render
  end
end