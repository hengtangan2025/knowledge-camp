# 推荐使用这个，已经把错误校验处理和提交处理包装好了
@SimpleDataForm = React.createClass
  getInitialState: ->
    errors: {}

  render: ->
    {
      Form
    } = DataForm

    <Form onSubmit={@on_submit} data={@props.data} errors={@state.errors}>
    {@props.children}
    </Form>

  on_submit: (data)->
    _data = {"#{@props.model}": data}
    console.log _data

    if @props.post
      type = 'post'
      url = @props.post
    else if @props.update
      type = 'update'
      url = @props.update

    jQuery.ajax
      url: url
      type: type
      data: _data
    .done (res)=>
      @props.done res
    .fail (res)=>
      console.debug res.responseJSON
      @setState errors: res.responseJSON


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

          <div className='field'>
            <label style={label_style}>
              {required_dom}
              <span>{@props.label}</span>
            </label>
            <div className='wrapper' style={wrapper_style}>
              {@props.children}
            </div>
          </div>


  Submit: React.createClass
    render: ->
      text = @props.text || '确定提交'

      <DataForm.Form.Field>
      {
        if @props.form.is_all_required_filled()
          <a className='ui button green small' href='javascript:;' onClick={@props.form.submit}>
            <i className='icon check' />
            {text}
          </a>
        else
          <a className='ui button green small disabled' href='javascript:;'>
            <i className='icon check' />
            {text}
          </a>
      }
      </DataForm.Form.Field>


  TextInputField: React.createClass
    render: ->
      <DataForm.Form.Field {...@props}>
        <input type='text' value={@props._value} onChange={@props._change} />
        {
          if @props._error_message
            <span>{@props._error_message}</span>
        }
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