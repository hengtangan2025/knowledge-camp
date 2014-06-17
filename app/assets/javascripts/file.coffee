class MindpinResumeableUploader
  constructor: (config)->
    @target         = config['target']
    @csrf_token     = config['csrf_token']
    @$browse_button = config['browse']

    @$uploader = config['uploader']
    @$item = @$uploader.find('.progress-item')
    @$list = @$uploader.find('.upload-list')

    @init()
    @events()

  init: ->
    @r = new Resumable
      target: @target
      headers:
        'X-CSRF-Token': @csrf_token
      chunkSize: 524288 # 1*1024*512
      testChunks: false
      simultaneousUploads: 1 # 最多同时上传一个，保证顺序
      generateUniqueIdentifier: (file)->
        "#{file.size}|#{file.name}"

    @r.assignBrowse @$browse_button[0]

  events: ->
    @r.on 'fileAdded', (file)=>
      $item = @$item.clone()
      $item.find('.name').html file.fileName
      $item.find('.bar').css 'width', '0'
      $item.find('.percent').html '0%'
      $item.find('.time').html '未知'
      $item.show().appendTo @$list

      file.$item = $item
      @r.upload()

    @r.on 'fileProgress', (file)=>
      percent = "#{(file.progress() * 100).toFixed()}%"
      $item = file.$item
      $item.find('.bar').css 'width', percent
      $item.find('.percent').html percent

ready = ->
  if jQuery('.page-manage-files-new').length > 0
    token_value = jQuery('meta[name=csrf-token]').attr('content')
    $button = jQuery('.page-manage-files-new a.select-file')
    target = $button.data('url')
    $uploader = jQuery('.page-file-uploader')

    new MindpinResumeableUploader({
      target: target
      csrf_token: token_value
      browse: $button
      uploader: $uploader
    })

jQuery(document).ready ready
jQuery(document).on 'page:load', ready