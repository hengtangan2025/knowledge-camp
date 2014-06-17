# 一开始用的是 Resumeable.js
# 然后改成了 Flow.js
# 话说这两个库的关系很纠结。
# 具体见 https://github.com/flowjs/flow.js/issues/1

class MindpinFlowUploader
  constructor: (config)->
    @target         = config['target']
    @csrf_token     = config['csrf_token']
    @$browse_button = config['browse']
    @$drop          = config['drop']
    @$uploader      = config['uploader']

    @$item = @$uploader.find('.progress-item')
    @$list = @$uploader.find('.upload-list')

    @init()
    @events()

  init: ->
    @r = new Flow
      target: @target
      headers:
        'X-CSRF-Token': @csrf_token
      chunkSize: 196608 # 1024 * 192 192K
      testChunks: true
      simultaneousUploads: 1 # 最多同时上传一个，保证顺序
      generateUniqueIdentifier: (file)->
        "#{file.size}|#{file.name}"

    @r.assignBrowse @$browse_button[0]
    @r.assignDrop @$drop[0]

    dc = 0
    @$drop.on 'dragenter', (evt)=>
      dc++
      @$drop.addClass 'over'

    @$drop.on 'dragleave drop', (evt)=>
      dc--
      if dc is 0
        @$drop.removeClass 'over'

  events: ->
    @r.on 'fileAdded', (file, event)=>
      console.log file, event
      @_clone_item(file)
      file.start_at = new Date().getTime()
      file.last_progress = 0

    @r.on 'filesSubmitted', (array, event)=>
      @r.upload()

    @r.on 'fileProgress', (file)=>
      $item = file.$item

      @__set_progress(file)
      @__set_remaining_time(file)

    @r.on 'fileSuccess', (file)=>
      setTimeout ->
        file.$item.addClass('completed')
      , 300

  _clone_item: (file)->
    $item = @$item.clone()
    file.$item = $item

    @__set_name(file)
    @__set_progress(file)
    @__set_remaining_time(file)
    @__set_extension_klass(file)
    
    $item.show().appendTo @$list


  __set_name: (file)->
    if file.$item
      file.$item.find('.name').html file.name

  __set_progress: (file)->
    if file.$item
      percent = "#{(file.progress() * 100).toFixed()}%"
      file.$item.find('.bar').css 'width', percent
      file.$item.find('.percent').html percent

  __set_remaining_time: (file)->
    if file.$item
      remaining = file.timeRemaining()
      remaining =
        if remaining == Number.POSITIVE_INFINITY
        then '未知'
        else @__human_time(remaining)

      file.$item.find('.remaining-time').html remaining

  __human_time: (remaining)->
    remaining += 1

    hour   = Math.floor(remaining / 3600)
    minute = Math.floor(remaining % 3600 / 60)
    second = remaining % 60

    hour = if hour >= 10 then hour else "0#{hour}"
    minute = if minute >= 10 then minute else "0#{minute}"
    second = if second >= 10 then second else "0#{second}"

    "#{hour}:#{minute}:#{second}"

  __set_extension_klass: (file)->
    if file.$item
      file.$item.addClass file.getExtension()

ready = ->
  if jQuery('.page-manage-files-new').length > 0
    token_value = jQuery('meta[name=csrf-token]').attr('content')
    $button = jQuery('.page-manage-files-new a.select-file')
    $drop = jQuery('.page-manage-files-new .file-box')
    target = $button.data('url')
    $uploader = jQuery('.page-file-uploader')

    new MindpinFlowUploader({
      target: target
      csrf_token: token_value
      browse: $button
      drop: $drop
      uploader: $uploader
    })

jQuery(document).on 'ready page:load', ready