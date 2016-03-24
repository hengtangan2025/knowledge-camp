# 推荐使用这个，已经把错误校验处理和提交处理包装好了
@SimpleDataForm = React.createClass
  getInitialState: ->
    errors: {}

  render: ->
    {
      Form
    } = DataForm

    <Form onSubmit={@on_submit} data={@props.data} errors={@state.errors} ref='form'>
    {@props.children}
    </Form>

  on_submit: (data)->
    _data = {"#{@props.model}": data}

    if @props.post
      type = 'post'
      url = @props.post
    else if @props.update
      type = 'update'
      url = @props.update

    @refs.form.set_submiting?(true)

    jQuery.ajax
      url: url
      type: type
      data: _data
    .done (res)=>
      @props.done res
    .fail (res)=>
      console.debug '表单提交错误响应数据：'
      console.debug res.responseJSON
      @setState errors: res.responseJSON
    .always =>
      @refs.form.set_submiting?(false)



# 更基础的一个组件，没有封装提交行为，有特殊需要时再使用
@DataForm =
  Form: React.createClass
    render: ->
      @required_names = []
      <DataForm.Form.DataKeeper form={@} data={@props.data} errors={@props.errors} ref='data_keeper'>
      {@props.children}
      </DataForm.Form.DataKeeper>

    get_data: ->
      @refs.data_keeper?.state

    submit: ->
      @props.onSubmit @get_data()

    is_all_required_filled: ->
      re = true
      for name in @required_names
        value = @get_data()?[name]
        re = re and not jQuery.is_blank(value)
      re

    statics:
      DataKeeper: React.createClass
        getInitialState: ->
          @props.data || {}

        render: ->
          @required_names = []

          fields = React.Children.map @props.children, (field)=>
            return field if typeof field is 'string'

            name = field.props?.name

            if field.props?.required
              @props.form.required_names.push name

            props =
              form:       @props.form
              _value:     @state[name]
              _change:    @on_change(name)
              _set_value: @do_change(name)
              _error_message: @props.errors?[name]?[0]

            React.cloneElement field, props

          <div className='ui small form data-form'>
          {fields}
          </div>

        on_change: (name)->
          (evt)=>
            @setState "#{name}": evt.target.value

        do_change: (name)->
          (value)=>
            @setState "#{name}": value

      Field: React.createClass
        render: ->
          label_style = 
            width: @props.label_width || '100px'

          wrapper_style =
            if @props.wrapper_width?
              width: @props.wrapper_width
            else
              flex: '1'

          required_dom = if @props.required
            <span className='required'>* </span>

          error_tip = if @props._error_message
            <div className='error-tip'>{@props._error_message}</div>

          klass = new ClassName
            'field': true
            'error': @props._error_message?

          <div className={klass}>
            <label style={label_style}>
              {required_dom}
              <span>{@props.label}</span>
            </label>
            <div className='wrapper' style={wrapper_style}>
              {@props.children}
              {error_tip}
            </div>
          </div>


  Submit: React.createClass
    getInitialState: ->
      is_submiting: false

    render: ->
      text = @props.text || '确定提交'

      klass = new ClassName
        'ui button green': true
        'loading': @state.is_submiting
        'disabled': not @is_valid()

      on_click = 
        if @is_valid() and not @state.is_submiting
        then @props.form.submit 
        else null

      button = 
        <a className={klass} href='javascript:;' onClick={on_click}>
          <i className='icon check' />
          {text}
        </a>

      <DataForm.Form.Field>
      {button}
      </DataForm.Form.Field>

    componentWillMount: ->
      @props.form.set_submiting = (is_submiting)=>
        @setState is_submiting: is_submiting

    is_valid: ->
      @props.form.is_all_required_filled()


  TextInputField: React.createClass
    render: ->
      <DataForm.Form.Field {...@props}>
        <input type='text' value={@props._value} onChange={@props._change} />
      </DataForm.Form.Field>

  TextAreaField: React.createClass
    render: ->
      rows = @props.rows || 5

      <DataForm.Form.Field {...@props}>
        <textarea rows={rows} onChange={@props._change}>
        {@props._value}
        </textarea>
      </DataForm.Form.Field>

  OneImageUploadField: null # 在 data_form/image_upload.coffee 中定义