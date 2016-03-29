jQuery.is_blank = (obj)->
  not obj || jQuery.trim(obj) == ''

jQuery.blank_or = (obj, re)->
  unless jQuery.is_blank(obj)
  then obj
  else re