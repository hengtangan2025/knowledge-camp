@InlineInputEdit = React.createClass
  getInitialState: ->
    value: @props.value
    is_editing: false

  render: ->
    if @state.is_editing
      params =
        context: @
        bind: 'value'
        on_submit: @value_changed

      <div className='inline-input-edit ui input'>
        <SimpleInput className='inline-edit-text-ipt' type='text' {...params} ref='ipt'/>
      </div>
    else
      <div className='inline-input-edit'>
        <div className='inline-edit-text' data-content='点击即可编辑' ref='text' onClick={@edit}>{@state.value}</div>
      </div>

  componentDidMount: ->
    # jQuery React.findDOMNode @refs.text
    #   .popup()

  componentDidUpdate: ->
    @refs.ipt?.focus()

  edit: ->
    # jQuery React.findDOMNode @refs.text
    #   .popup('hide')

    @setState
      is_editing: true

  value_changed: ->
    @setState
      is_editing: false

    @props.on_submit @state.value
