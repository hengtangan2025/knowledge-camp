class DandelionCell < Cell::Rails
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

    @keys     = @klass.fields.keys
    # TODO 需要有自行配置显示哪些字段和如何显示的方法

    @edit_url = File.join "/", @klass.model_name.route_key, 'edit'

    render
  end
end