class CurveArrow
  constructor: (@canvas)->
    # nothing

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