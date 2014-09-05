class CurveArrow
  constructor: (@canvas)->
    # nothing

  draw_by_dom: ($dom0, $dom1, color)->
    # x0 = $dom0.data('left') + $dom0.outerWidth() / 2
    # x1 = $dom1.data('left') + $dom0.outerWidth() / 2

    # bt = $dom0.data('top')
    # et = $dom1.data('top')

    # if bt < et
    #   y0 = bt + $dom0.outerHeight()
    #   y1 = et
    # else
    #   y0 = bt
    #   y1 = et + $dom1.outerHeight()

    x0 = $dom0.data('left') + $dom0.outerWidth() / 2
    y0 = $dom0.data('top') + $dom0.outerHeight()

    if $dom0.data('left') > $dom1.data('left')
      x1 = $dom1.data('left') + $dom1.outerWidth()
      y1 = $dom1.data('top') + $dom1.outerHeight() / 2
    else
      x1 = $dom1.data('left') + $dom1.outerWidth() / 2
      y1 = $dom1.data('top')

    @draw(x0, y0, x1, y1, color)

  draw: (x0, y0, x1, y1, color)->
    # console.log '绘制曲线箭头', [x0, y0], [x1, y1]

    W = x1 - x0
    H = y1 - y0
    L = Math.pow Math.pow(H, 2) + Math.pow(W, 2), 0.5

    # 计算曲线辅助点
    l = 10
    # l = L / 3
    dx = l * H / L
    dy = l * W / L
    xm = (x0 + x1) / 2 + dx
    ym = (y0 + y1) / 2 - dy

    ctx = @canvas.getContext '2d'
    ctx.fillStyle = color
    ctx.strokeStyle = color
    ctx.lineWidth = 2
    ctx.lineCap = 'round'

    # ctx.beginPath()
    # ctx.arc x0, y0, 3, 0, Math.PI, false
    # ctx.closePath()
    # ctx.fill()

    ctx.beginPath()
    ctx.moveTo x0, y0
    ctx.quadraticCurveTo xm, ym, x1, y1
    ctx.stroke()

    # 画箭头
    xp = (x0 + x1) / 2 + dx / 2
    yp = (y0 + y1) / 2 - dy / 2

    hx = 6
    ang = Math.atan ~~(xp - x1) / ~~(y1 - yp)
    ang += Math.PI if yp > y1
    # ang -= Math.PI / 2

    # console.log ang

    ctx.save()
    ctx.translate x1, y1
    ctx.rotate ang
    ctx.beginPath()
    ctx.moveTo -hx/1.2, -hx
    ctx.lineTo 0, 0
    ctx.lineTo hx/1.2, -hx
    ctx.stroke()
    ctx.restore()


window.CurveArrow = CurveArrow

# --------------------

class SelectList
  constructor: (@$elm, @mainform)->
    @$btn_ok = @$elm.find('.btn.ok')
    @$btn_cancel = @$elm.find('.btn.cancel')
    @$list = @$elm.find('.list')

    @$template_item = @$elm.find('.template .item')

    @bind_events()

    @close_func = -> {}

  bind_events: ->
    # 列表项被点击
    that = @
    @$list.delegate '.item', 'click', ->
      that.select_item jQuery(this)

    @$btn_ok.on 'click', => @on_ok()
    @$btn_cancel.on 'click', => @on_cancel()

  select_item: ($item)->
    @$list.find('.item').removeClass('selected')
    @$selected_item = $item.addClass('selected')
    @$btn_ok.removeClass('disabled')

  open: (data_list, funcs)->
    funcs ||= {}
    @ok_func = funcs.on_ok || -> {}
    @open_func = funcs.on_open || -> {}
    @close_func = funcs.on_close || -> {}


    @open_func()

    @$elm.show(200)
    @$list.html('')
    @$btn_ok.addClass('disabled')

    if data_list.length is 0
      jQuery('<div>')
        .addClass('blank')
        .html('没有可选择的选项')
        .appendTo @$list
      return

    for data in data_list
      $item = @$template_item.clone()
      $item
        .data('id', data.id)
        .data('text', data.text)
        .find('.text').html(data.text).end()
        .appendTo @$list

      @select_item $item if data.selected

    @$elm.show 200

  close: ->
    @close_func()
    @$elm.hide 200
    @mainform.$form
      .find('.assigns').removeClass('active').end()
      .find('.assigns .item').removeClass('active').end()


  on_ok: ->
    return if @$btn_ok.hasClass('disabled')
    return if not @$selected_item
    @ok_func @$selected_item

  on_cancel: ->
    @close()



window.SelectList = SelectList