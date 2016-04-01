# 参考 SAMPLE_CSUBJECTS_DATA
@TreeDataParser = class
  constructor: (tree_data)->
    @items = Immutable.fromJS tree_data.items
    @relations = Immutable.fromJS tree_data.relations

    @items_set = Immutable.fromJS {}
    @items.forEach (x)=>
      @items_set = @items_set.set(x.get('id'), x)

  get_depth_first_array: ->
    parent_children_set = Immutable.fromJS {}
    child_parents_set = Immutable.fromJS {}

    @relations.forEach (r)->
      parent_id = r.get(0)
      child_id = r.get(1)

      children = parent_children_set.get(parent_id) || Immutable.fromJS([])
      children = children.push child_id
      parent_children_set = parent_children_set.set(parent_id, children)

      parents = child_parents_set.get(child_id) || Immutable.fromJS([])
      parents = parents.push parent_id
      child_parents_set = child_parents_set.set(child_id, parents)

    res = Immutable.fromJS []
    stack = @items_set

    _r = (x, depth_array)=>
      res = res.push x
      stack = stack.delete x.get('id')

      children = parent_children_set.get(x.get('id')) || Immutable.fromJS([])
      children = children.map (id)=>
        @items_set.get id
      children.forEach (c, idx)->
        is_last_sibling = idx == children.size - 1
        child_depth_array = depth_array.push is_last_sibling
        c = c
          .set '_depth_array', child_depth_array
          .set '_depth', child_depth_array.size
          .set '_is_last_sibling', is_last_sibling

        _r c, child_depth_array

    
    root_items = @items.filter (x)->
      id = x.get('id')
      parents = child_parents_set.get id
      not parents?

    root_items.forEach (x, idx)->
      is_last_sibling = idx == root_items.size - 1
      child_depth_array = Immutable.fromJS [is_last_sibling]

      x = x
        .set '_depth_array', child_depth_array
        .set '_depth', child_depth_array.size
        .set '_is_last_sibling', is_last_sibling

      _r x, child_depth_array

    return res.toJS()
