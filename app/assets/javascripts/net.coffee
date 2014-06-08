duration = 200
load_animate = false

animate_visit = (path)->
  jQuery('.page-content')
    .animate
      'margin-top': '+=50'
      'opacity': 0
    , duration, ->
      load_animate = true
      Turbolinks.visit(path)

jQuery(document).on 'page:load', ->
  if load_animate
    load_animate = false
    jQuery('.page-content')
      .css 
        'margin-top': '+=50'
        'opacity': 0
      .animate
        'margin-top': '-=50'
        'opacity': 1
      , duration

jQuery(document).on 'page:restore', ->
  jQuery('.page-content')
    .css
      'margin-top': ''
      'opacity': ''

# -------------------

jQuery(document).delegate '.page-manage-nets-index a.create-net', 'click', (evt)->
  evt.preventDefault();
  href = jQuery(this).attr('href')
  animate_visit href


jQuery(document).delegate '.page-net-form a.cancel', 'click', (evt)->
  evt.preventDefault();
  href = jQuery(this).attr('href')
  animate_visit href