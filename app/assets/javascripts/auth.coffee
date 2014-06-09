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
      console.log res
    error: (res)->
      show_auth_error '用户名/密码不正确'

show_auth_error = (msg)->
  jQuery('.sign-in-form .auth-msg')
    .html msg
    .css
      'opacity': 0
      'margin-left': 0
    .show()
    .animate
      'opacity': 1
      'margin-left': 30
