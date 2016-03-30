jQuery.is_blank = (obj)->
  not obj || jQuery.trim(obj) == ''

jQuery.blank_or = (obj, re)->
  unless jQuery.is_blank(obj)
  then obj
  else re

jQuery.flatten_tree = (tree_array, key)->
  tree_data = Immutable.fromJS tree_array
  res = Immutable.fromJS []

  _r = (item, depth)->
    x = item.delete(key).set('_depth', depth)
    res = res.push x

    children = item.get(key)

    children?.forEach (child, idx)->
      c = 
        if idx == children.size - 1
          child.set('_level_last', true) 
        else
          child

      _r c, depth + 1

  tree_data.forEach (item)->
    _r item, 0

  res.toJS()