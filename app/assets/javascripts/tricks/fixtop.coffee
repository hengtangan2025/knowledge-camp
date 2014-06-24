# fixtop：当网页向下滚动到一定程度时，
# 有些元素需要固定浮动在页面顶端
# 工程内支持以两种方式添加浮动效果
# 一是在 dom 上以 data-fixtop-offset 声明
# 二是以 add_fixtop 方法指定元素

_fixtop_data = []

# 令指定元素具有 fixtop 特性
# offset 为触发距离，
# 当窗口滚动到距元素顶部距离超过 offset 时
# 触发浮动效果
add_fixtop = ($elm, offset, zidx)->
  zindex = zidx || 1 
  ot = $elm.offset().top
  data = 
    elm: $elm
    offset: offset
    origintop: ot
    triggertop: ot - offset
    zindex: zindex
  _fixtop_data.push data

# 初始化以 data-fixtop-offset 声明的元素
init_fixtop_data = ->
  jQuery('[data-fixtop-offset]').each (index, elm)->
    $elm = jQuery(elm)
    offset = $elm.data('fixtop-offset')
    add_fixtop $elm, offset

jQuery(document).on 'ready page:load', ->
  _fixtop_data = []
  init_fixtop_data()

check_fixtop = ->
  scrolltop = jQuery(document).scrollTop()
  for data in _fixtop_data
    $elm = data.elm

    if scrolltop > data.triggertop
      $elm
        .addClass('-fixtop')
        .css
          'position': 'fixed'
          'top': data.offset
          'left': $elm.offset().left
          'width': $elm.width()
          'z-index': data.zindex
    else
      $elm
        .removeClass('-fixtop')
        .css
          'position': ''
          'top': ''
          'left': ''
          'width': ''

jQuery(document).on 'scroll', check_fixtop

window.add_fixtop = add_fixtop
window.check_fixtop = check_fixtop