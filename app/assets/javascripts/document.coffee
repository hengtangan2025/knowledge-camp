jQuery(document).on 'ready page:load', ->
  $editor = jQuery('.document .content-editor')

  if $editor.length > 0
    $editor.hide()

    ue = new UE.ui.Editor
      toolbars: [[
        'bold', 'underline', 'strikethrough', 
        'insertorderedlist', 'insertunorderedlist',
        'quote', 'link', 'unlink'
        'source'
      ]]

    ue.ready ->
      $editor.fadeIn(200)

    ue.render $editor[0]