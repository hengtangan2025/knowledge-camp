# 就绪，上传中，远程处理完毕，本地处理完毕，错误
@UploadStatus =
  READY:        'READY'          # percent = null
  UPLOADING:    'UPLOADING'      # percent = 0
  REMOTE_DONE:  'REMOTE_DONE'    # percent = 100
  LOCAL_DONE:   'LOCAL_DONE'     # percent = 100
  ERROR:        'ERROR'          # percent = null

@UploadWidget =
  BrowseButton: React.createClass
    render: ->
      style = switch @props.status
        when UploadStatus.READY
          opacity: 1
        when UploadStatus.UPLOADING, UploadStatus.REMOTE_DONE
          display: 'none'
        when UploadStatus.LOCAL_DONE, UploadStatus.ERROR
          opacity: 0

      <div className='browse-btn' {...window.$$browse_btn_data} style={style}>
      {@props.children}
      </div>

# @OneFileUpload = React.createClass
#   getInitialState: ->
#     status: UploadStatus.READY
#     percent: null
#     file_entity_id: null

#   render: ->
#     <div className='image-upload'>
#       <div className='browse' style={@props.browse_style}>
#         {@props.progress}
#         {@props.browse_button}
#       </div>
#       <input type='text' value={@state.file_entity_id} readOnly />
#     </div>