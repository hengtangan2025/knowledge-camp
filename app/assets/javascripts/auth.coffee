jQuery(document).delegate '.sign-in-form input[type=submit]', 'click', (evt)->
  evt.preventDefault()
  
  $form = jQuery(this).closest('form')
  data = $form.serialize()
  url = $form.attr('action')

  jQuery.ajax
    type: 'POST'
    url: url
    data: data
    success: (res)->
      show_auth_info 'success', '登录成功', ->
        Turbolinks.visit '/'
    error: (res)->
      show_auth_info 'error', '用户名/密码不正确'

show_auth_info = (klass, msg, func)->
  jQuery('.sign-in-form .auth-msg')
    .removeClass('error').removeClass('success')
    .addClass(klass)
    .html msg
    .css
      'opacity': 0
      'margin-left': 0
    .show()
    .animate
      'opacity': 1
      'margin-left': 30
    , ->
      console.log func
      func() if func