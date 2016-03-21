OneImageUpload = React.createClass
  getInitialState: ->
    status: 'ready' # uploading, remote_done, local_done, error
    percent: 0

  render: ->
    width = 640
    height = 360

    h = 180
    w = width * h / height

    browse_style = 
      width: "#{w}px"
      height: "#{h}px"

    <div className='image-upload'>
      <div className='browse' style={browse_style}>
        {
          if @state.status != 'ready'
            params =
              percent: @state.percent
              status: @state.status
              preview_url: @state.preview_url

            <OneImageUpload.Percent {...params} />
        }
        {
          style = switch @state.status
            when 'ready'
              opacity: 1
            when 'local_done', 'error'
              opacity: 0
            else
              display: 'none'

          params =
            data: @props.data
            title: @props.title || '上传图片'
            desc: @props.desc ||
              <div>
                支持 PNG/JPG/BMP 格式，最大 3MB <br/>
                建议图片尺寸大于 640×360px，最佳比例 16:9
              </div>

          <OneImageUpload.BrowseBtn {...params} ref='browse_btn' style={style} />
        }
      </div>
      <input type='hidden' value={@props.value} readOnly />
    </div>

  set_file_entity_id: (id)->
    @props._set_value id

  statics:
    BrowseBtn: React.createClass
      render: ->
        # 从 window.file_part_upload_dom_data 获取
        # {
        #   "qiniu_domain":       "http://xxx.xxx.xxx.xxx.clouddn.com",
        #   "qiniu_base_path":    "kc",
        #   "qiniu_uptoken_url":  "/file_part_upload/file_entities/uptoken", 
        #   "qiniu_callback_url": "/file_part_upload/file_entities"
        # }

        fd = window.file_part_upload_dom_data
        if not fd?
          console.warn '没有找到包含 qiniu_domain, qiniu_base_path, qiniu_uptoken_url, qiniu_callback_url 的上传组件配置信息'

        browse_btn_data =
          'data-qiniu-domain':        fd?.qiniu_domain
          'data-qiniu-base-path':     fd?.qiniu_base_path
          'data-qiniu-uptoken-url':   fd?.qiniu_uptoken_url
          'data-qiniu-callback-url':  fd?.qiniu_callback_url

        <div className='browse-btn' {...browse_btn_data} style={@props.style}>
          <div className='btn-text'>
            <div className='header'>＋ {@props.title}</div>
            <div className='desc'>{@props.desc}</div>
          </div>
        </div>

    Percent: React.createClass
      render: ->
        bar_style = 
          width: "#{100 - @props.percent}%"

        percent_style =
          if @props.preview_url
            backgroundImage: "url(#{@props.preview_url})"

        <div className='percent' style={percent_style} >
          {
            if @props.status is 'uploading'
              <div className='bar' style={bar_style} />
          }
          {
            switch @props.status
              when 'uploading'
                <div className='p'>{@props.percent}%</div>
              when 'remote_done'
                <div className='p'>
                  <div className='ui active inverted loader' />
                </div>
              when 'local_done'
                <div className='p'><i className='icon check circle' /></div>
          }
        </div>

  componentDidMount: ->
    $browse_button = jQuery React.findDOMNode @refs.browse_btn

    new QiniuFilePartUploader
      browse_button:        $browse_button
      dragdrop_area:        null
      file_progress_class:  @generate_progress()
      max_file_size:        '3mb' 
      mime_types :          [{ title: 'Image files', extensions: 'png,jpg,jpeg,bmp' }]

  generate_progress: ->
    that = this

    class
      constructor: (qiniu_uploading_file, @uploader)->
        @file = qiniu_uploading_file
        that.setState
          percent: 0
          status: 'uploading'

        reader = new FileReader()
        reader.readAsDataURL @file.getNative()
        reader.onload = (e)=>
          that.setState preview_url: e.target.result

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
        # console.log "file error"
        # console.log up, err, err_tip

      # 当七牛上传成功，尝试创建 file_entity 时，此方法会被调用
      deal_file_entity: (info)->
        that.setState status: 'remote_done'

        qiniu_domain = window.file_part_upload_dom_data?.qiniu_domain
        remote_url = "#{qiniu_domain}/#{info.token}"
        jQuery("<img src='#{remote_url}' />").load ->
          that.setState preview_url: remote_url

      file_entity_error: (xhr)->
        # console.log "file entity error"
        # console.log xhr.responseText

      # 出现全局错误时（如文件大小超限制，文件类型不对），此方法会被调用
      @uploader_error: (up, err, err_tip)->
        # console.log "uploader error"
        # console.log up, err, err_tip

      # 所有上传队列项处理完毕时（成功或失败），此方法会被调用
      @alldone: ->
        # console.log "alldone"


@DataForm.OneImageUploadField = React.createClass
  render: ->
    title = @props.title || '上传图片'
    
    <DataForm.Form.Field {...@props}>
      <OneImageUpload done={@props._set_value} value={@props._value} />
    </DataForm.Form.Field>