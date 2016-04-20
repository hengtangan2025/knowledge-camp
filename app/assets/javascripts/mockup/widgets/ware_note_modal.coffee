@WareNoteModal = React.createClass
  getInitialState: ->
    notes: null

  render: ->
    ware = @props.ware

    {
      TextInputField
      TextAreaField
      Submit
    } = DataForm

    layout =
      label_width: '60px'

    form = 
      <div style={borderTop: 'solid 1px #ddd', marginTop: '1rem', paddingTop: '1rem'}>
        <h4 className='ui header'>提一个问题：</h4>
        <DataForm.Form ref='form' onSubmit={@submit}>
          <TextInputField {...layout} label='标题：' name='title' required />
          <TextAreaField {...layout} label='描述：' name='content' rows={5} required />
          <Submit {...layout} text='确定提问' />
        </DataForm.Form>
      </div>

    <div>
      {
        if @state.notes == null
          <div className='ui segment basic'>
          <div className="ui active inverted dimmer">
            <div className="ui text loader">正在加载</div>
          </div>
          </div>

        else 
          <div>
          {
            if @state.notes.length is 0
              <div>你还没有记录笔记</div>
            else
              for note in @state.notes
                <div key={note.id} className='note'>
                </div>
          }
          {form}
          </div>
      }
      <div className='ops' style={marginTop: '2rem'}>
        <a className='ui button' onClick={@close} style={marginLeft: '60'}>
          <i className='icon close' /> 关闭
        </a>
      </div>
    </div>

  submit: ->
    jQuery.ajax
      url: '/notes'
      data:
        note: @refs.form.get_data()
        ware_id: @props.ware.id

  close: ->
    @state.close()

  componentDidMount: ->
    jQuery.ajax
      url: '/notes/ware'
      data:
        ware_id: @props.ware.id
    .done (res)=>
      @setState notes: res.notes
      @state.refresh()