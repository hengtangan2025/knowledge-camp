# fixtop：当网页向下滚动到一定程度时，
# 有些元素需要固定浮动在页面顶端
# 工程内支持以两种方式添加浮动效果
# 一是在 dom 上以 data-fixtop-offset 声明
# 二是以 Fixtop.add() 方法指定元素

window.Fixtop = class Fixtop
  @DATA: []

  ###
    令指定元素具有 fixtop 特性
    offset 为触发距离，
    当窗口滚动到距元素顶部距离超过 offset 时
    触发浮动效果
  ###
  @add: ($elm, offset, zidx)->
    # @clear {elm: $elm}
    
    zindex = zidx || 1 
    ot = $elm.offset().top

    @DATA.push
      elm: $elm
      offset: offset
      origintop: ot
      triggertop: ot - offset
      zindex: zindex

  @clear: ->
    @DATA = []

  @run: ->
    scrolltop = jQuery(document).scrollTop()
    for data in @DATA
      if scrolltop > data.triggertop
        @add_fix_css(data)
      else
        @remove_fix_css(data)

  @add_fix_css: (data)->
    $elm = data.elm
    $elm
      .addClass('-fixtop')
      .css
        'position': 'fixed'
        'top': data.offset
        'left': $elm.offset().left
        'width': $elm.width()
        'z-index': data.zindex

  @remove_fix_css: (data)->
    $elm = data.elm
    $elm
      .removeClass('-fixtop')
      .css
        'position': ''
        'top': ''
        'left': ''
        'width': ''

  @page_init: ->
    jQuery('[data-fixtop-offset]').each ->
      $elm = jQuery(this)
      offset = $elm.data('fixtop-offset')
      Fixtop.add $elm, offset
      # console.log Fixtop.DATA


jQuery(document).on 'ready page:load', ->
  Fixtop.page_init()

jQuery(document).on 'page:fetch', ->
  Fixtop.clear()

jQuery(document).on 'page:restore', ->
  jQuery('.-fixtop').each ->
    $elm = jQuery(this)
    Fixtop.remove_fix_css {elm: $elm}
  Fixtop.page_init()

jQuery(document).on 'scroll', ->
  Fixtop.run()