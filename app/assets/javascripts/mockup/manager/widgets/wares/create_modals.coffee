@CreateWare =
  video: (chapter)->
    ->
      open_modal <CreateWareForm.Video chapter={chapter} />


CreateWareForm =  
  Video: React.createClass
    displayName: 'CreateWareForm.Video'
    render: ->
      <div>
        <h4>上传视频</h4>
        <VideoUpload />
        <a href='javascript:;' className='ui button small' onClick={@close}>
          <i className='icon check' /> 关闭
        </a>
      </div>

    close: ->
      React.unmountComponentAtNode @state.$modal_dom.find('.content')[0]

      @state
        .$modal_dom
        .modal('hide')
        .remove()


open_modal = (component)->
  $dom = jQuery """
    <div class="ui modal ware">
      <div class="content">
      </div>
    </div>
  """
    .appendTo document.body

  a = React.render component, $dom.find('.content')[0]
  a.setState $modal_dom: $dom

  $dom
    .modal
      blurring: true
      closable: false
    .modal('show')