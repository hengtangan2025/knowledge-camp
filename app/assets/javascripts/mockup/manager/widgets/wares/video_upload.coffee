@VideoUpload = React.createClass
  getInitialState: ->
    status: 'ready' # uploading, remote_done, local_done, error
    percent: 0

  render: ->
    browse_style = 
      width: "100%"
      height: "90px"

    <div className='widget-video-upload'>
      <div className='browse' style={browse_style}>
        {
          if @state.status != 'ready'
            params =
              percent: @state.percent
              status: @state.status

            <VideoUpload.Percent {...params} />
        }
        {
          style = switch @state.status
            when 'ready'
              opacity: 1
            when 'local_done', 'error'
              opacity: 0
            else
              display: 'none'

          <VideoUpload.BrowseBtn ref='browse_btn' style={style} />
        }
      </div>
      <input type='hidden' value={@props.value} readOnly />
    </div>

  set_file_entity_id: (id)->
    @props._set_value id

  statics:
    BrowseBtn: React.createClass
      render: ->
        <div className='browse-btn' {...window.$$browse_btn_data} style={@props.style}>
          <div className='btn-text'>
            <div className='header'>＋ 点击上传视频</div>
          </div>
        </div>

    # props: percent, status
    Percent: React.createClass
      render: ->
        percent = @props.percent

        bar_style = 
          'transition-duration': '300ms'
          'width': "#{percent}%"

        <div className='ui teal progress' data-percent={percent}>
          <div className='bar' style={bar_style}>
          </div>
          <div className='label'>{percent}% 已上传</div>
        </div>

  componentDidMount: ->
    $browse_button = jQuery React.findDOMNode @refs.browse_btn

    new QiniuFilePartUploader
      browse_button:        $browse_button
      dragdrop_area:        null
      file_progress_class:  @generate_progress()
      max_file_size:        '1024mb' 
      mime_types :          [{ title: 'Video Files', extensions: '*' }]

  generate_progress: ->
    that = this

    class
      constructor: (qiniu_uploading_file, @uploader)->
        @file = qiniu_uploading_file
        that.setState
          percent: 0
          status: 'uploading'

      # 某个文件上传进度更新时，此方法会被调用
      update: ->
        jQuery({ num: that.state.percent })
          .animate { num: @file.percent }, {
            step: (num)=>
              that.setState percent: Math.ceil num
          }

      # 某个文件上传成功时，此方法会被调用
      success: (info)->
        that.props.done info.id
        that.setState status: 'local_done'

      # 某个文件上传出错时，此方法会被调用
      file_error: (up, err, err_tip)->

      # 当七牛上传成功，尝试创建 file_entity 时，此方法会被调用
      deal_file_entity: (info)->
        that.setState status: 'remote_done'

      file_entity_error: (xhr)->

      # 出现全局错误时（如文件大小超限制，文件类型不对），此方法会被调用
      @uploader_error: (up, err, err_tip)->

      # 所有上传队列项处理完毕时（成功或失败），此方法会被调用
      @alldone: ->
