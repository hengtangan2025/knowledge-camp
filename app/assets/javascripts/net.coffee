# index grid
do ->
  jQuery(document).delegate '.cell-manage-nets.grid .net .box', 'click', (evt)->
    link = jQuery(this).data('link')
    new UIToggle(link).visit()