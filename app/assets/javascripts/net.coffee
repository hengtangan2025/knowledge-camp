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

# new
do ->
  jQuery(document).delegate '.page-manage-nets-index a.create-net', 'click', (evt)->
    evt.preventDefault();
    href = jQuery(this).attr('href')
    animate_visit href


  jQuery(document).delegate '.page-net-form a.cancel', 'click', (evt)->
    evt.preventDefault();
    href = jQuery(this).attr('href')
    animate_visit href


# index grid
do ->
  jQuery(document).delegate '.cell-manage-nets.grid .net .box', 'click', (evt)->
    link = jQuery(this).data('link')
    animate_visit link

  jQuery(document).delegate '.page-manage-nets-show .nav .back a', 'click', (evt)->
    evt.preventDefault();
    href = jQuery(this).attr('href')
    animate_visit href