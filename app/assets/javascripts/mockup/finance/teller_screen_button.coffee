@TellerScreenButton = React.createClass
  render: ->
    <a href='javascript:;' className='ui basic button mini' onClick={@show}>
      <i className='icon desktop' /> {@props.hmdm}
    </a>

  show: ->
    TellerScreenButton.load_modal @props.hmdm

  statics:
    load_modal: (hmdm)->
      hmdm_url = window.hmdm_url
      unless hmdm_url?
        console.warn '未设置 window.hmdm_url'
        return 

      jQuery.ajax
        url: hmdm_url
        data: hmdm: hmdm
      .done (screen)=>
        jQuery.open_modal <OFCTellerScreen key={screen.hmdm} data={screen} />