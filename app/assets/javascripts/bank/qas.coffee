jQuery(document).on 'ready page:load', ->
  jQuery('.cell-qa-question, .cell-qa-answer').on 'click', 'a.answers-toggle', ->
    $this = jQuery(this)
    $media = $this.closest('.media')
    if $media.hasClass('open')
      $media.removeClass('open')
    else
      $media.addClass('open')
