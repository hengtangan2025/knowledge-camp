class WebVideoCkPlayer

  constructor: (@$elm)->
    @PLAYER_SWF_URL = '/ckplayer/ckplayer.swf'
    @elm_id = @$elm.attr('id')

    @video_list_xml_url = @$elm.data('xmlurl')
    @video_file_url = @$elm.data('fileurl')

    @init()

  init: ->
    if @video_list_xml_url
      vars =
        p: 0 # 默认暂停，不自动播放
        c: 1 # 读取 xml 配置，不使用 js 配置
        f: @video_list_xml_url
        s: 2 # 从 xml 读取视频文件信息，而不是直接传文件 url
    else if @video_file_url
      vars =
        p: 0 # 默认暂停，不自动播放
        c: 1 # 读取 xml 配置，不使用 js 配置
        f: @video_file_url

    params =
      bgcolor : '#161616'
      allowFullScreen : true
      allowScriptAccess : 'always'
      wmode : 'opaque'

    CKobject.embedSWF @PLAYER_SWF_URL, @elm_id, 'mindpin_ckplayer', '100%', '100%', vars, params

    @player = CKobject.getObjectById('mindpin_ckplayer')

    video = [
      'http://oss-cn-hangzhou.aliyuncs.com/pie_test_001/dev_documents/20140424/DFBE707C3F8984C34787A074DC41F031.mp4->video/mp4'
    ]
    support = [
      'iPad', 'iPhone', 'ios', 
      'android+false', 'msie10+false', 
      'webKit+false', 'gecko+false'
    ]
    CKobject.embedHTML5 @elm_id, 'mindpin_ckplayer', '100%', 'auto', video, vars, support

do ->
  jQuery(document).on 'ready page:load', ->
    if jQuery('.page-video-player').length
      player = new WebVideoCkPlayer jQuery('.page-video-player')