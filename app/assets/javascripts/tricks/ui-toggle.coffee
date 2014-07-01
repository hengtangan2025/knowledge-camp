###
  Turbolinks.AniToggle
  ====================================
  给页面切换增加动画效果


  使用方法：
    给 <a> 标签增加 data-toggle 属性

    html:
    <a href='...' data-toggle>...</a>

    haml:
    %a{:href => '...', :data => {:toggle => true}} ...

  这样，点击这个链接的时候就会调用页面切换动画效果来切换到新页面


  注意事项：
    需要在 turbolinks 库之后加载
###

###
  切换方式：
    out_mode:
      fade: 平滑渐隐
      down: 平滑渐隐 + 下移
      open: 平滑渐隐 + 两侧打开

    in_mode:
      fade: 平滑渐现
      up:   平滑渐现 + 上移
      close: 平滑渐现 + 两侧合拢
###
class Animator
  constructor: (@out_mode, @in_mode)->
    @DURATION = AniToggle.DURATION

  out: (func)->
    fname = "_out_#{@out_mode}"
    f = @[fname]
    return f(func) if f

    console.log "未定义 Animator.#{fname}(func) 方法"

  in: ->
    fname = "_in_#{@in_mode}"
    f = @[fname]
    return f() if f

    console.log "未定义 Animator.#{fname}(func) 方法"

  __out_callback: (func)->
    func()
    jQuery(document).one 'page:change', =>
      @in()

  # 由于调用方式特殊，以下方法都需要用 => 来定义
  _out_fade: (func)=>
    jQuery('.page-content')
      .addClass('-toggle-animated')
      .data('-toggle-restore', ['opacity'])
      .animate
        'opacity': 0
      , @DURATION, => @__out_callback(func)

  _out_down: (func)=>
    jQuery('.page-content')
      .addClass('-toggle-animated')
      .data('-toggle-restore', ['margin-top', 'opacity'])
      .animate
        'margin-top': '+=50'
        'opacity': 0
      , @DURATION, => @__out_callback(func)

  _out_open: (func)=>
    jQuery('.page-content .page-side')
      .addClass('-toggle-animated')
      .data('-toggle-restore', ['left', 'opacity'])
      .animate
        'left': "-=50"
        'opacity': 0
      , @DURATION 

    jQuery('.page-content .page-main')
      .addClass('-toggle-animated')
      .data('-toggle-restore', ['left', 'opacity'])
      .animate
        'left': "+=50"
        'opacity': 0
      , @DURATION, => @__out_callback(func)

  # ----------------

  _in_fade: =>
    jQuery('.page-content')
      .css
        'opacity': 0
      .animate
        'opacity': 1
      , @DURATION

  _in_up: =>
    jQuery('.page-content')
      .css
        'margin-top': '+=50'
        'opacity': 0
      .animate
        'margin-top': '-=50'
        'opacity': 1
      , @DURATION

  _in_close: =>
    jQuery('.page-content .page-side')
      .css
        'left': '-50px'
        'opacity': 0
      .animate
        'left': '0'
        'opacity': 1
      , @DURATION

    jQuery('.page-content .page-main')
      .css
        'left': '+50px'
        'opacity': 0
      .animate
        'left': '0'
        'opacity': 1
      , @DURATION



Turbolinks.AniToggle = class AniToggle
  @DEBUG: true
  @DURATION: 200

  ###
    调用方法：
    Turbolinks.AniToggle.visit("/foo/bar")
    Turbolinks.AniToggle.visit("/foo/bar", ['fade', 'fade'])
  ###
  @visit: (href, toggle)->
    if toggle instanceof Array
      ani = new Animator toggle[0], toggle[1]
    else
      ani = new Animator('down', 'up')

    ani.out ->
      Turbolinks.visit href


do ->
  jQuery(document).delegate 'a[data-toggle]', 'click', (evt)->
    evt.preventDefault();
    href   = jQuery(this).attr('href')
    toggle = jQuery(this).data('toggle')

    Turbolinks.AniToggle.visit(href, toggle)

  jQuery(document).on 'page:restore', ->
    jQuery('.-toggle-animated').each ->
      $elm = jQuery(this)
      for style in $elm.data('-toggle-restore')
        $elm.css style, ''