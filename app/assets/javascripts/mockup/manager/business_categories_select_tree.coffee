@BusinessCategoriesSelectTree = React.createClass
  getInitialState: ->
    checked_leaf_item_ids: @props.data.checked_leaf_item_ids

  render: ->
    <div className="business-categories-select-tree">
    {
      for item in @props.data.items
        data =
          item:             item
          item_check_state: @item_check_state
          taggle_item_check_state: @taggle_item_check_state
          dept: 0
        <BusinessCategoriesSelectTree.Item data={data} />
    }
    </div>

  value: ->
    @state.checked_leaf_item_ids

  get_leaf_descendant: (item)->
    leaf_descendant = []

    _digui_get_children = (_item)->
      children = _item.children || []
      for child in children
        _children = child.children || []
        if _children.length == 0
          leaf_descendant.push child
        else
          _digui_get_children(child)

    _digui_get_children(item)

    if item.children.length == 0
      leaf_descendant.push item
    leaf_descendant

  item_check_state: (item)->
    if @state.checked_leaf_item_ids.indexOf(item.id) != -1
      return "checked"

    items = @get_leaf_descendant(item)
    checked_items = items.filter (x)=>
      @state.checked_leaf_item_ids.indexOf(x.id) != -1

    return "unchecked" if checked_items.length == 0
    return "checked" if checked_items.length == items.length
    return "partchecked"

  taggle_item_check_state: (item)->
    switch @item_check_state(item)
      when "checked"
        @unchecked_item(item)
      when "unchecked"
        @checked_item(item)
      when "partchecked"
        @checked_item(item)

  checked_item: (item)->
    checked_leaf_item_ids = @state.checked_leaf_item_ids

    for x in @get_leaf_descendant(item)
      if checked_leaf_item_ids.indexOf(x.id) == -1
        checked_leaf_item_ids.push x.id

    @setState
      checked_leaf_item_ids: checked_leaf_item_ids

  unchecked_item: (item)->
    checked_leaf_item_ids = @state.checked_leaf_item_ids

    for x in @get_leaf_descendant(item)
      index = checked_leaf_item_ids.indexOf(x.id)
      if index != -1
        checked_leaf_item_ids.splice(index, 1)

    @setState
      checked_leaf_item_ids: checked_leaf_item_ids

  statics:
    Item: React.createClass
      render: ->
        if @props.data.dept == 0
          open_close_classname = "open"
        else
          open_close_classname = "close"
        <div className="item #{open_close_classname}">
          <div className="line">
            {@get_icon_dom()}
            {@get_checkbox_dom()}
            <div className="name">{@props.data.item.name}</div>
          </div>
          {
            if @has_children()
              <div className="children" >
              {
                for item in @props.data.item.children
                  item.parent = @props.data.item
                  data =
                    item:                    item
                    item_check_state:        @props.data.item_check_state
                    taggle_item_check_state: @props.data.taggle_item_check_state
                    dept: @props.data.dept + 1
                  <BusinessCategoriesSelectTree.Item data={data} />
              }
              </div>
          }
        </div>

      get_checkbox_dom: ()->
        <div
          className="checkbox #{@props.data.item_check_state(@props.data.item)}"
          onClick={@taggle_check_state()}
          >
          <div className="inner">
          </div>
        </div>

      taggle_check_state: ->
        =>
          @props.data.taggle_item_check_state(@props.data.item)

      get_icon_dom: ()->
        if @has_children()
          <div className="taggle-icon" onClick={@taggle_classname}>
            <i className="angle right icon"></i>
            <i className="angle down icon"></i>
          </div>
        else
          <div className="taggle-icon place-holder">
          </div>

      taggle_classname: ->
        $div = jQuery(React.findDOMNode(@))
        $div.toggleClass("close")
        $div.toggleClass("open")

      has_children: ->
        @props.data.item.children.length != 0
