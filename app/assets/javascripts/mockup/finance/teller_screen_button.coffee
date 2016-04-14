@TellerScreenButton = React.createClass
  render: ->
    <a href='javascript:;' className='ui basic button mini' onClick={@show}>
      <i className='icon desktop' /> {@props.hmdm}
    </a>

  show: ->
    TellerScreenButton.load_modal @props.hmdm

  statics:
    Modal: React.createClass
      render: ->
        screen = @props.screen

        <div>
          <OFCTellerScreen key={screen.hmdm} data={screen} />
          <div style={textAlign: 'right', marginTop: '2rem'}>
            <a href='javascript:;' className='ui button' onClick={@close}>关闭</a>
          </div>
        </div>

      close: ->
        @state.close()

    load_modal: (hmdm)->
      hmdm_url = window.hmdm_url
      unless hmdm_url?
        console.warn '未设置 window.hmdm_url'
        return 

      jQuery.ajax
        url: hmdm_url
        data: hmdm: hmdm
      .done (screen)=>
        jQuery.open_modal(
          <TellerScreenButton.Modal screen={screen}/>, {
            allowMultiple: true
          }
        )