jQuery(document).on 'ready page:load', ->
  jQuery('.page-course-study').on 'click', '.intro-button', ->
    jQuery(this).popover('toggle')
