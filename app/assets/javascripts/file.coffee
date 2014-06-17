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
      chunkSize: 196608 # 1024 * 192 192K
      testChunks: true
      simultaneousUploads: 1 # 最多同时上传一个，保证顺序
      generateUniqueIdentifier: (file)->
        "#{file.size}|#{file.name}"

    @r.assignBrowse @$browse_button[0]

  events: ->
    @r.on 'fileAdded', (file)=>
      @_clone_item(file)
      @r.upload()
      file.start_at = new Date().getTime()
      file.last_progress = 0

    @r.on 'fileProgress', (file)=>
      percent = "#{(file.progress() * 100).toFixed()}%"
      $item = file.$item
      $item.find('.bar').css 'width', percent
      $item.find('.percent').html percent

      delta = new Date().getTime() - file.start_at
      progress = file.progress()

      if progress > file.last_progress 
        file.last_progress = progress

        remaining = Math.ceil(delta * (1 - progress) / progress / 1000)

        hour   = Math.floor(remaining / 3600)
        minute = Math.floor(remaining % 3600 / 60)
        second = remaining % 60

        hour = if hour >= 10 then hour else "0#{hour}"
        minute = if minute >= 10 then minute else "0#{minute}"
        second = if second >= 10 then second else "0#{second}"

        $item.find('.remaining-time').html "#{hour}:#{minute}:#{second}"

    @r.on 'fileSuccess', (file)=>
      setTimeout ->
        file.$item.addClass('completed')
      , 300

  _clone_item: (file)->
    $item = @$item.clone()
    $item.find('.name').html file.fileName
    $item.find('.bar').css 'width', '0'
    $item.find('.percent').html '0%'
    $item.find('.remaining-time').html '未知'
    $item.show().appendTo @$list

    a = file.fileName.split(".")
    if a.length is 1 or ( a[0] is "" and a.length is 2)
      klass = ""
    else
      klass = a.pop().toLowerCase()

    $item.addClass(klass)

    file.$item = $item

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