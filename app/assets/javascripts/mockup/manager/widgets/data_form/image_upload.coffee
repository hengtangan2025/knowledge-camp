# 用法：
# <OneImageUpload done={callback} value={value} />
# callback 回调方法，会被传入 file_entity.id
# value 预设值，用于“编辑修改”场景

OneImageUpload = React.createClass
  getInitialState: ->
    # 就绪，上传中，远程处理完毕，本地处理完毕，错误
    status: UploadStatus.READY
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
          if @state.status != UploadStatus.READY
            params =
              percent: @state.percent
              status: @state.status
              preview_url: @state.preview_url

            <OneImageUpload.Progress {...params} />
        }
        {
          title = @props.title || '上传图片'
          desc = @props.desc ||
            <div>
              支持 PNG/JPG/BMP 格式，最大 3MB <br/>
              建议图片尺寸大于 640×360px，最佳比例 16:9
            </div>

          <UploadWidget.BrowseButton ref='browse_btn' status={@state.status}>
            <div className='btn-text'>
              <div className='header'>＋ {title}</div>
              <div className='desc'>{desc}</div>
            </div>
          </UploadWidget.BrowseButton>
        }
      </div>
      <input type='hidden' value={@props.value} readOnly />
    </div>

  statics:
    Progress: React.createClass
      render: ->
        bar_style = 
          width: "#{100 - @props.percent}%"

        percent_style =
          if @props.preview_url?
            backgroundImage: "url(#{@props.preview_url})"

        <div className='percent' style={percent_style} >
          {
            if @props.status is UploadStatus.UPLOADING
              <div className='bar' style={bar_style} />
          }
          {
            switch @props.status
              when UploadStatus.UPLOADING
                <div className='p'>{@props.percent}%</div>
              when UploadStatus.REMOTE_DONE
                <div className='p'>
                  <div className='ui active inverted loader' />
                </div>
              when UploadStatus.LOCAL_DONE
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
          status: UploadStatus.UPLOADING

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
        that.setState status: UploadStatus.LOCAL_DONE

      # 某个文件上传出错时，此方法会被调用
      file_error: (up, err, err_tip)->

      # 当七牛上传成功，尝试创建 file_entity 时，此方法会被调用
      deal_file_entity: (info)->
        that.setState status: UploadStatus.REMOTE_DONE

        qiniu_domain = window.file_part_upload_dom_data?.qiniu_domain
        remote_url = "#{qiniu_domain}/#{info.token}"
        jQuery("<img src='#{remote_url}' />").load ->
          that.setState preview_url: remote_url

      file_entity_error: (xhr)->

      # 出现全局错误时（如文件大小超限制，文件类型不对），此方法会被调用
      @uploader_error: (up, err, err_tip)->

      # 所有上传队列项处理完毕时（成功或失败），此方法会被调用
      @alldone: ->


@DataForm.OneImageUploadField = React.createClass
  render: ->
    title = @props.title || '上传图片'
    
    <DataForm.Form.Field {...@props}>
      <OneImageUpload done={@props._set_value} value={@props._value} />
    </DataForm.Form.Field>