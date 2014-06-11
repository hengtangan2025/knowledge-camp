jQuery(document).delegate '.page-users-form .submit a.save', 'click', (evt)->
    evt.preventDefault()

    data = []

    $form = jQuery(this).closest('.page-users-form')
    $form.find('.user').each ->
      $user = jQuery(this)
      val1 = jQuery.trim $user.find('.ipt.login input').val()
      val2 = jQuery.trim $user.find('.ipt.name input').val()
      data.push [val1, val2] if val1.length > 0

    if data.length > 0
      url = jQuery(this).attr('href')
      jQuery.ajax
        url: url
        type: 'POST'
        data: 
          users: data
        success: (res)->
          new UIToggle(url).visit()



jQuery(document).delegate '.page-users-form .users .user input', 'focus', (evt)->
  jQuery('.page-users-form .users .user').removeClass 'focus'

  $user = jQuery(this).closest('.user')
  $user.addClass('focus')

jQuery(document).delegate '.page-users-form .users .user input', 'blur', (evt)->
  $user = jQuery(this).closest('.user')
  val1 = jQuery.trim $user.find('.ipt.login input').val()
  val2 = jQuery.trim $user.find('.ipt.name input').val()

  if val1.length > 0
    $user.addClass('ok')
  else
    $user.removeClass('ok')

jQuery(document).delegate '.page-users-form .users .user input', 'keydown', (evt)->
    $user = jQuery(this).closest('.user')
    $ipt  = jQuery(this).closest('.ipt')

    klass = 'login' if $ipt.hasClass('login')
    klass = 'name' if $ipt.hasClass('name')

    $prev = $user.prev('.user')
    $next = $user.next('.user')

    switch evt.which
      when 38  # ↑
        evt.preventDefault()
        $prev.find(".ipt.#{klass} input").focus()

      when 40  # ↓
        evt.preventDefault()
        $next.find(".ipt.#{klass} input").focus()

      when 37  # ←
        if caret(jQuery(this)[0]) is 0
          evt.preventDefault()
          $user.find('.ipt.login input').focus()

      when 39  # →
        if caret(jQuery(this)[0]) is jQuery(this).val().length
          evt.preventDefault()
          $user.find('.ipt.name input').focus()

      when 9   # tab
        evt.preventDefault()
        if klass is 'login'
          $user.find('.ipt.name input').focus()
        if klass is 'name'
          if $next.length is 0
            jQuery(this).closest('.users')
              .find('.user:first-child')
              .find(".ipt.login input").focus()
          else
            $next.find(".ipt.login input").focus()

      when 13  # enter
        evt.preventDefault()
        if klass is 'login'
          $user.find('.ipt.name input').focus()
        if klass is 'name'
          if $next.length is 0
            add_line($user)
          $user.next('.user').find(".ipt.login input").focus()

add_line = ($user)->
  $new_user = $user.clone()
  $new_user.find('input').val('')

  $user.after $new_user

caret = (node)->
  if node.selectionStart 
    return node.selectionStart

  else if(!document.selection) 
    return 0

  c    = "\u0001"
  sel  = document.selection.createRange()
  txt  = sel.text
  dul  = sel.duplicate()
  len  = 0

  try
    dul.moveToElementText(node)
  catch e
    return 0

  sel.text = txt + c
  len = dul.text.indexOf(c)
  sel.moveStart('character', -1)
  sel.text = ""
  return len