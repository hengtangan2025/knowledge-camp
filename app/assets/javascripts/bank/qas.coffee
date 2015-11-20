jQuery(document).on 'ready page:load', ->
  jQuery('.cell-qa-question a.answers-toggle').on 'click', ->
    $this = jQuery(this)
    $media = $this.closest('.media')
    if $media.hasClass('open')
      $media.removeClass('open')
    else
      $media.addClass('open')
