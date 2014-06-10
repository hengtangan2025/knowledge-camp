on_animate = false

class UIToggle
  @DURATION: 200
  @ANIMATE: false

  constructor: (@path)->
    #

  visit: (toggle)->
    unless toggle instanceof Array
      [t0, t1] = ['down', 'up']
    else
      [t0, t1] = toggle

    if t0 is 'down'
      return @_visit_down t1

    if t0 is 'open'
      return @_visit_open t1


  _visit_down: (t1)->
    jQuery('.page-content')
      .animate
        'margin-top': '+=50'
        'opacity': 0
      , UIToggle.DURATION, =>
        UIToggle.ANIMATE = t1
        Turbolinks.visit(@path)

  _visit_open: (t1)->
    jQuery('.page-content .page-side')
      .animate
        'left': "-=50"
        'opacity': 0

    jQuery('.page-content .page-main')
      .animate
        'left': "+=50"
        'opacity': 0
      , UIToggle.DURATION, =>
        UIToggle.ANIMATE = t1
        Turbolinks.visit(@path)


window.UIToggle = UIToggle

jQuery(document).on 'page:load', ->
  if !!UIToggle.ANIMATE
    tin = UIToggle.ANIMATE
    UIToggle.ANIMATE = false

    if tin is 'up'
      jQuery('.page-content')
        .css 
          'margin-top': '+=50'
          'opacity': 0
        .animate
          'margin-top': '-=50'
          'opacity': 1
        , UIToggle.DURATION

    if tin is 'close'
      jQuery('.page-content .page-side')
        .css
          'left': '-50px'
          'opacity': 0
        .animate
          'left': "0"
          'opacity': 1
        , UIToggle.DURATION

      jQuery('.page-content .page-main')
        .css
          'left': '+50px'
          'opacity': 0
        .animate
          'left': "0"
          'opacity': 1
        , UIToggle.DURATION


# reset
jQuery(document).on 'page:restore', ->
  jQuery('.page-content')
    .css
      'margin-top': ''
      'opacity': ''

  jQuery('.page-content .page-side')
    .css
      'left': ''
      'opacity': ''

  jQuery('.page-content .page-main')
    .css
      'left': ''
      'opacity': ''

do ->
  jQuery(document).delegate 'a[data-toggle]', 'click', (evt)->
    evt.preventDefault();
    href = jQuery(this).attr('href')
    toggle = jQuery(this).data('toggle')

    new UIToggle(href).visit(toggle)