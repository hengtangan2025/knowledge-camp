jQuery(document).delegate '.note .link a', 'click', ->
  $o = jQuery('.note-overlay')
  if $o.is(":visible")
    $o.slideUp(100)
  else
    $o.slideDown(100)