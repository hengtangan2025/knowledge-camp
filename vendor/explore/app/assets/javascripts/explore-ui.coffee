# -------------- header

jQuery(document).delegate '.page-header a.toggle', 'click', ->
  jQuery('.page-drawer-front').toggleClass('open')

# -------------- circle-progress
jQuery(document).on 'ready page:load', ->
  jQuery('.page-progress-circle').each (index, elm)->
    $elm = jQuery(elm)
    return if $elm.hasClass('done')

    stroke_color = $elm.data('stroke') || '#4CC85E'
    percent = $elm.data('percent')
    canvas = $elm.find('canvas')[0]
    ctx = canvas.getContext('2d')
    width = canvas.width
    radius = width / 2

    start = - Math.PI / 2
    end = - Math.PI / 2 + Math.PI / 180 * (360 / 100 * percent)

    ctx.beginPath()
    ctx.strokeStyle = stroke_color
    ctx.lineWidth = canvas.width / 10
    ctx.arc(radius, radius, radius - ctx.lineWidth / 2.0, start, end, false)
    ctx.stroke()


jQuery(document).delegate '.note .link a', 'click', ->
  $o = jQuery('.note-overlay')
  if $o.is(":visible")
    $o.slideUp(100)
  else
    $o.slideDown(100)

# ----------

jQuery(document).on 'ready page:load', ->
  open_step = (id)->
    $target_step = jQuery(".steps-flow .step[data-id=#{id}]")
    $target_step.fadeIn 200, ->
      $target_step.find('.page-fit-image')
        .removeClass('initialized')
        .find('img').remove()
      jQuery(document).trigger 'mindpin:new-content-appended'

  if jQuery('.steps-flow').length
    jQuery('.steps-flow .step').hide().first().show()

    jQuery('.steps-flow .step .continue a.go').click ->
      $step = jQuery(this).closest('.step')
      targetid = jQuery(this).data('targetid')
      console.log targetid

      open_step(targetid)
      $continue = jQuery(this).closest('.continue')
      $continue.hide 200

    jQuery('.steps-flow .step .continue .option').click ->
      id = jQuery(this).data('id')
      $options = jQuery(this).closest('.options')
      $options.closest('.select').data('id', id)
      
      $options.find('.option').removeClass('checked')
      jQuery(this).addClass('checked')


    jQuery('.steps-flow .step .continue a.submit').click ->
      id = jQuery(this).closest('.select').data('id')
      if id
        open_step(id)
        $continue = jQuery(this).closest('.continue')
        $continue.find('a').hide(200)
        $continue.find('.option').not('.checked').hide(200)

jQuery(document).on 'ready page:load', ->
  if jQuery('.steps-flow').length
    jQuery('.steps-flow .step .marks .note').click ->
      jQuery('.mark-overflow')
        .removeClass('disabled')
        .addClass('note')

    jQuery('.steps-flow .step .marks .question').click ->
      jQuery('.mark-overflow')
        .removeClass('disabled')
        .addClass('question')

    jQuery('.mark-overflow a.cancel').click ->
      jQuery('.mark-overflow')
        .addClass('disabled')
        .removeClass('note')
        .removeClass('question')


# ----------------- web flow
jQuery(document).on 'ready page:load', ->
  if jQuery('.page-explore-tutorials-webflow-web').length
    $webflow = jQuery('.webflow')
    $page_next = $webflow.find('a.page.next')
    $page_prev = $webflow.find('a.page.prev')

    select = (num)->
      step = jQuery(".webflow .steps .step").eq(num - 1)

      o1 = parseInt step.offset().left
      o2 = parseInt $webflow.find('.steps').offset().left
      m1 = parseInt $webflow.find('.steps .step').first().css 'margin-left'

      # console.log d = o1 - o2 - m1
      d = o1 - o2 - m1

      $webflow.find('.steps .step').first()
        .stop()
        .animate
          'margin-left': -d+1
        , ->
          jQuery(document).trigger 'mindpin:load-fit-images'

      $webflow.find('a.pg')
        .removeClass('active')
        .eq(num - 1).addClass('active')

      $webflow.find('a.page').removeClass('disabled')
      if num is $webflow.find('.steps .step').length
        $page_next.addClass 'disabled'
      if num is 1
        $page_prev.addClass 'disabled'

    $webflow.delegate '.pages a.pg', 'click', ->
      num = jQuery(this).data('num')
      select num

    $webflow.delegate 'a.page.next:not(.disabled)', 'click', ->
      num = jQuery('.webflow a.pg.active').data('num') + 1
      select num

    $webflow.delegate 'a.page.prev:not(.disabled)', 'click', ->
      num = jQuery('.webflow a.pg.active').data('num') - 1
      select num