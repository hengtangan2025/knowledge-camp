@DataForm =
  Form: React.createClass
    getInitialState: ->
      @props.data || {}

    render: ->
      <div className='ui small form manager-form'>
      {
        React.Children.map @props.children, (child)=>
          return child if typeof child is 'string'
          props = {
            form: @
          }
          React.cloneElement child, props
      }
      </div>

    on_change: (name)->
      (evt)=>
        @setState "#{name}": evt.target.value

    submit: ->
      @props.onSubmit @state

  Field: React.createClass
    render: ->
      label_style = 
        if not @props.label_width
          {width: '100px'}
        else
          {width: @props.label_width}

      wrapper_style =
        if not @props.wrapper_width
          {flex: '1'}
        else
          {width: @props.wrapper_width}

      <div className='field'>
        <label style={label_style}>{@props.label}</label>
        <div className='wrapper' style={wrapper_style}>
        {
          React.Children.map @props.children, (child)=>
            return child if typeof child is 'string'
            name = child.props?.name
            props = {
              form: @props.form
              _change: @props.form.on_change(name)
              _value: @props.form.state[name]
            }

            React.cloneElement child, props
        }
        </div>
      </div>

  Submit: React.createClass
    render: ->
      <a className='ui button green small' href='javascript:;' onClick={@submit}>
        <i className='icon check' />
        {@props.text}
      </a>

    submit: ->
      @props.form.submit()

  # ---------------
  # 各种输入域子组件
  # ---------------

  TextInput: React.createClass
    render: ->
      <input type='text' value={@props._value} onChange={@props._change} />

  TextArea: React.createClass
    render: ->
      rows = @props.rows || 5
      <textarea rows={rows} onChange={@props._change}>
      {@props._value}
      </textarea>
