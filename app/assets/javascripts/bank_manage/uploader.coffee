jQuery(document).on 'ready page:load', ->
  # 课程封面
  class CourseCoverProgress
    constructor: (uploading_file, @uploader)->
      @file = uploading_file
      console.log @file
      window.afile = @file

    # 上传进度进度更新时调用此方法
    update: ->
      console.log "qiniu update"
      console.log "#{@file.percent}%"
      jQuery('.cover_process').html "上传中...#{@file.percent}%"

    # 上传成功时调用此方法
    success: (info)->
      console.log "qiniu success"
      console.log info
      $cover = jQuery('#img_course_cover')

      jQuery('#course_cover').val(info.file_entity_url)

      if $cover.length > 0
        $cover.prop('src', info.file_entity_url) 

      else
        jQuery('.cover_preview').append """
          <img id="img_course_cover" class="img-responsive" src="#{info.file_entity_url}" />
        """

      jQuery('.cover_process').html "上传成功!"

    # 上传出错时调用此方法
    error: ->
      console.log "qiniu error"

    @alldone: ->
      console.log "qiniu alldone"

  # 相关资料
  class CourseAttachmentProgress
    constructor: (uploading_file, @uploader)->
      @file = uploading_file
      console.log @file
      window.afile = @file
      jQuery('#upload_result').html('')
      jQuery('.btn-upload-attachment').button('上传中')

    # 上传进度进度更新时调用此方法
    update: ->
      console.log "qiniu update"
      console.log "#{@file.percent}%"

    # 上传成功时调用此方法
    success: (info)->
      console.log "qiniu success"
      console.log info

      jQuery('#course_cover_file_entity_id').val(info.file_entity_id)
      jQuery('#upload_result').html('上传成功')

    # 上传出错时调用此方法
    error: ->
      console.log "qiniu error"
      jQuery('#upload_result').html('上传失败')

    @alldone: ->
      console.log "qiniu alldone"
      jQuery('.btn-upload-attachment').button('reset')

  if jQuery('.btn-upload').length
    $browse_button = jQuery('.btn-upload')
    $dragdrop_area = jQuery(document.body)

    new FilePartUploader
      browse_button: $browse_button
      dragdrop_area: $dragdrop_area
      file_progress: CourseCoverProgress

  if jQuery('.btn-upload-attachment').length
    $attachment_upload_button = jQuery('.btn-upload-attachment')
    $dragdrop_area = jQuery(document.body)

    new FilePartUploader
      browse_button: $attachment_upload_button
      dragdrop_area: $dragdrop_area
      file_progress: CourseAttachmentProgress


  # 课件
  class WareProgress
    constructor: (uploading_file, @uploader)->
      @file = uploading_file
      console.log @file
      console.log 'WareProgress'
      window.afile = @file

      jQuery('.btn-submit').prop('disabled', 'disabled')
      jQuery('.btn-submit span').html('上传中...')
      $ware_title = jQuery('#ware_title')
      $ware_title.val(@file.name) if $ware_title.length > 0 and $ware_title.val() == ''
      jQuery('#ware-upload-progress').html('0%').css('width', '0%')
      jQuery('#ware-info-tab').tab('show')

    # 上传进度进度更新时调用此方法
    update: ->
      console.log "qiniu update"
      console.log "#{@file.percent}%"
      jQuery('#ware-upload-progress').html("#{@file.percent}%").css('width', "#{@file.percent}%")

    # 上传成功时调用此方法
    success: (info)->
      console.log "qiniu success"
      console.log info

      jQuery('#ware_file_entity_id').val(info.file_entity_id)
      jQuery('.btn-submit').prop('disabled', null)
      jQuery('.btn-submit span').html('保存')

    # 上传出错时调用此方法
    error: ->
      console.log "qiniu error"
      jQuery('.btn-submit span').html('上传失败,请重新上传')

    @alldone: ->
      console.log "qiniu alldone"

  if jQuery('.btn-ware-upload').length
    $ware_upload_button = jQuery('.btn-ware-upload')
    $dragdrop_area = jQuery(document.body)

    jQuery('.btn-submit').prop('disabled', 'disabled')
    jQuery('.btn-submit span').html('请先上传文件')

    new FilePartUploader
      browse_button: $ware_upload_button
      dragdrop_area: $dragdrop_area
      file_progress: WareProgress

