jQuery(document).on 'ready page:load', ->

  class QiniuFileProgress
    constructor: (uploading_file, @uploader)->
      @file = uploading_file
      console.log @file
      @started = false

      $item = QiniuFileProgress.$item.clone()
      @file.$item = $item
      @__set_name()
      @__set_progress()
      @__set_remaining_time()
      @__set_extension_klass()
      @file.$item.show().appendTo QiniuFileProgress.$list
      QiniuFileProgress.$container.find('.ops a.submit').addClass('disabled')

    # 上传进度进度更新时调用此方法
    update: ->
      console.log "qiniu update"
      console.log "#{@file.percent}%"
      if !@started
        @file.start_at = new Date().getTime()
        @started = true

      @__set_progress()
      @__set_remaining_time()

    # 上传成功时调用此方法
    success: (info)->
      console.log "qiniu success"
      console.log info

      if !QiniuFileProgress.data
        QiniuFileProgress.data = {}

      file_entity_id = info['file_entity_id']
      QiniuFileProgress.data[file_entity_id] = @file.name

      setTimeout =>
        @file.$item.addClass('completed')
      , 300

    # 上传出错时调用此方法
    error: ->
      console.log "qiniu error"

      setTimeout =>
        @file.$item.addClass('error')
      , 300

    @alldone: ->
      console.log "qiniu alldone"
      setTimeout =>
        if QiniuFileProgress.data
          QiniuFileProgress.$container.find('.ops a.submit').removeClass('disabled')
      , 300

    __set_name: ->
      @file.$item.find('.name').html @file.name

    __set_progress: ->
      percent = "#{@file.percent}%"
      @file.$item.find('.bar').css 'width', percent
      @file.$item.find('.percent').html percent

    __set_remaining_time: ->
      seconds = (new Date().getTime() - @file.start_at) / 1000
      remaining = (@file.size - @file.loaded) / (@file.loaded / seconds)

      remaining =
        if remaining == Number.POSITIVE_INFINITY
        then '未知'
        else @__human_time(remaining)

      @file.$item.find('.remaining-time').html remaining

    __human_time: (remaining)->
      remaining += 1

      hour   = Math.floor(remaining / 3600)
      minute = Math.floor(remaining % 3600 / 60)
      second = remaining % 60

      hour = if hour >= 10 then hour else "0#{hour}"
      minute = if minute >= 10 then minute else "0#{minute}"
      second = if second >= 10 then second else "0#{second}"

      "#{hour}:#{minute}:#{second}"

    __set_extension_klass: ->
      strs = @file.name.split(".")
      ext = strs[strs.length-1]
      @file.$item.addClass ext

  class KcUpload
    constructor: (@$container)->
      QiniuFileProgress.$container = @$container

      $uploader = jQuery('.page-file-uploader')
      QiniuFileProgress.$item = $uploader.find('.progress-item')
      QiniuFileProgress.$list = $uploader.find('.upload-list')

      console.log @$container.find('a.select-file')
      window.abc = @$container.find('a.select-file')
      new FilePartUploader
        browse_button: @$container.find('a.select-file')
        dragdrop_area: @$container.find('.file-box')
        file_progress: QiniuFileProgress

      @bind_event()

    bind_event: ->
      @$container.find('.ops a.submit').on 'click', (evt)->
        $button = jQuery(this)
        return if $button.hasClass('disabled')

        url = $button.data('url')

        jQuery.ajax
          url: url
          type: 'POST'
          data:
            files: QiniuFileProgress.data
          success: (res)->
            Turbolinks.AniToggle.visit(url, ['open', 'close'])


  if jQuery('.page-manage-files-new').length
    new KcUpload jQuery('.page-manage-files-new')

#--------------------------

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

    @file_added_func = config['file_added_func']
    @complete_func   = config['complete_func']


    @$item = @$uploader.find('.progress-item')
    @$list = @$uploader.find('.upload-list')

    @init()
    @events()

    @data = {}

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
      @_clone_item(file)
      file.start_at = new Date().getTime()
      file.last_progress = 0

      @file_added_func()

    @r.on 'filesSubmitted', (array, event)=>
      @r.upload()

    @r.on 'fileProgress', (file)=>
      $item = file.$item

      @__set_progress(file)
      @__set_remaining_time(file)

    @r.on 'fileSuccess', (file, message)=>
      file_entity_id = JSON.parse(message)['file_entity_id']
      @data[file_entity_id] = file.name

      setTimeout ->
        file.$item.addClass('completed')
      , 300

    @r.on 'complete', (file)=>
      setTimeout =>
        @complete_func()
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

  get_data: ->
    @data
    # [key, @data[key]] for key of @data

ready = ->
  if jQuery('.page-manage-files-new').length > 0
    $container = jQuery('.page-manage-files-new')
    uploader = _init_uploader $container
    _init_submit_button(uploader, $container)

  if jQuery('.page-manage-point-files-new').length > 0
    $container = jQuery('.page-manage-point-files-new')
    uploader = _init_uploader $container
    _init_submit_button(uploader, $container)


_init_uploader = ($container)->
  token_value = jQuery('meta[name=csrf-token]').attr('content')
  $button = $container.find('a.select-file')
  $drop = $container.find('.file-box')
  target = $button.data('url')
  $uploader = jQuery('.page-file-uploader')

  new MindpinFlowUploader({
    target: target
    csrf_token: token_value
    browse: $button
    drop: $drop
    uploader: $uploader
    file_added_func: ->
      $container.find('.ops a.submit').addClass('disabled')
    complete_func: ->
      $container.find('.ops a.submit').removeClass('disabled')
  })

_init_submit_button = (uploader, $container)->
  $container.find('.ops a.submit').on 'click', (evt)->
    $button = jQuery(this)
    return if $button.hasClass('disabled')

    data = uploader.get_data()
    url = $button.data('url')

    jQuery.ajax
      url: url
      type: 'POST'
      data:
        files: data
      success: (res)->
        Turbolinks.AniToggle.visit(url, ['open', 'close'])


# jQuery(document).on 'ready page:load', ready


# 排版方法
# ----------------------
class GridLayout
  constructor: (@$grid)->
    @col = @$grid.data('cols')

  layout: ->
    stack = []
    @$grid.find('.gcell').each (index, cell)=>
      if index % @col is 0
        @_layout_stack(stack)
        stack = []
      stack.push cell
    @_layout_stack(stack)

  _layout_stack: (stack)->
    max_height = 0
    for cell in stack
      height = jQuery(cell).height()
      max_height = height if height > max_height

    for cell in stack
      jQuery(cell).height(max_height)

jQuery(document).on 'ready page:load', ->
  if jQuery('.cell-manage-files.grid').length > 0
    new GridLayout(jQuery('.cell-manage-files.grid')).layout()
