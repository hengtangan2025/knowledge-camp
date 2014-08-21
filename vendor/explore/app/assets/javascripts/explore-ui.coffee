# -------------- header

jQuery(document).delegate '.page-header a.toggle', 'click', ->
  jQuery('.page-drawer-front').toggleClass('open')

# --------------



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