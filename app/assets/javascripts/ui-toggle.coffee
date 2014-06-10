on_animate = false

class UIToggle
  @DURATION: 200
  @ANIMATE: false

  constructor: (@path)->
    #

  visit: ->
    jQuery('.page-content')
      .animate
        'margin-top': '+=50'
        'opacity': 0
      , UIToggle.DURATION, =>
        UIToggle.ANIMATE = 'down-up'
        Turbolinks.visit(@path)

window.UIToggle = UIToggle

jQuery(document).on 'page:load', ->
  if !!UIToggle.ANIMATE
    UIToggle.ANIMATE = false
    jQuery('.page-content')
      .css 
        'margin-top': '+=50'
        'opacity': 0
      .animate
        'margin-top': '-=50'
        'opacity': 1
      , UIToggle.DURATION

do ->
  jQuery(document).delegate 'a.ui-toggle', 'click', (evt)->
    evt.preventDefault();
    href = jQuery(this).attr('href')
    new UIToggle(href).visit()