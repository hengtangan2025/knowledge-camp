@ManagerBusinessCategoriesPage = React.createClass
  getInitialState: ->
    business_categories = @props.data.business_categories || []
    business_categories: business_categories

  render: ->
    <div className='manager-business-categories-page'>
    {
      if @state.business_categories.length is 0
        data =
          header: '业务类别设置'
          desc: '还没有创建任何业务类别'
          init_action: 
            <ManagerBusinessCategoriesPage.CreateBtn />
        <ManagerFuncNotReady data={data} />
      else
        tdp = new TreeArrayParser @state.business_categories
        flatten_business_categories = tdp.get_depth_first_array()

        <div>
          <ManagerBusinessCategoriesPage.Table flatten_business_categories={flatten_business_categories} />
          <div className='ui segment btns'>
            <ManagerBusinessCategoriesPage.CreateBtn />
          </div>
        </div>
    }
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @, @state.business_categories

  statics:
    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href='javascript:;' onClick={@create_root_category}>
          <i className='icon plus' /> 增加新业务类别
        </a>

      create_root_category: ->
        Actions.add_category
          name: "新业务类别 #{new Date().getTime()}"

    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '业务类别名称'
            ops: ''
            number: '对应交易代码'
          data_set: @props.flatten_business_categories.map (x)=> 
            {
              id: x.id
              name:
                <ManagerBusinessCategoriesPage.TreeItemTD data={x} />
              number:
                <InlineInputEdit value={x.number} on_submit={@update_number(x)} />
              ops:
                <div>
                  <a href='javascript:;' className='ui green basic button mini' onClick={@create_category_on(x)}>
                    <i className='icon plus' /> 增加子级
                  </a>
                  <a href='javascript:;' className='ui red basic button mini' onClick={@confirm_remove(x)}>
                    <i className='icon remove' /> 删除
                  </a>
                </div>
            }
          th_classes: {
            number: 'collapsing'
          }
          td_classes: {
            ops: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='业务类别' />
        </div>

      update_number: (category)->
        (number)->
          Actions.update_category category, {
            number: number
          }

      create_category_on: (category)->
        ->
          Actions.add_category_on category, {
            name: "新业务类别 #{new Date().getTime()}"
          }

      confirm_remove: (category)->
        ->
          jQuery.modal_confirm
            text: '确定要删除吗？'
            yes: =>
              Actions.remove_category category


    TreeItemTD: React.createClass
      render: ->
        x = @props.data

        <div className='tree-item'>
          <div className='tree-pds'>
          {
            for flag, idx in x._depth_array
              klass = new ClassName
                'pd': true
                'flag': flag 

              <div key={idx} className={klass}></div>
          }
          </div>
          <div className='item-name'>
            <InlineInputEdit value={x.name} on_submit={@update_name(x)} />
          </div>
        </div>

      update_name: (category)->
        (name)->
          Actions.update_category category, {
            name: name
          }



# ----------------------

class DataStore
  constructor: (@page, business_categories)->
    @business_categories = Immutable.fromJS business_categories
    @create_business_category_url = @page.props.data.create_business_category_url

  create_category: (data)->
    if not @create_business_category_url?
      console.warn '没有传入 create_business_category_url 接口'
      return

    jQuery.ajax
      type: 'POST'
      url: @create_business_category_url
      data: 
        business_category: data
    .done (res)=>
      if res.id?
        @_push_data_into_tree res
      else
        console.warn '创建业务类别请求没有返回正确数据'

    .fail (res)->
      console.log res.responseJSON

  _push_data_into_tree: (res)->
    new_category = Immutable.fromJS res
    business_categories = @business_categories.push new_category
    @reload_page business_categories

  delete_category: (category)->
    if not category.delete_url?
      console.warn '没有传入 category.delete_url 接口'
      return

    jQuery.ajax
      type: 'DELETE'
      url: category.delete_url
    .done (res)=>
      business_categories = @_delete_data_from_tree @business_categories, category
      @reload_page business_categories
    .fail (res)->
      console.log res.responseJSON

  _delete_data_from_tree: (categories, category)->
    children = categories.filter (r)->
      r.get('parent_id') == category.id

    children.forEach (c)=>
      categories = @_delete_data_from_tree categories, c.toJS()

    categories = categories.filter (x)->
      x.get('id') != category.id

  update_category: (category, data)->
    if not category.update_url?
      console.warn '没有传入 category.update_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      url: category.update_url
      data:
        business_category: data
    .done (res)=>
      @reload_page @business_categories.map (x)->
        x = x.merge data if x.get('id') is category.id
        x
    .fail (res)->
      console.log res.responseJSON

  reload_page: (business_categories)->
    @business_categories = business_categories
    @page.setState
      business_categories: business_categories.toJS()


Actions = class
  @set_store: (store)->
    @store = store

  @add_category: (data)->
    @store.create_category {
      name: data.name
    }

  @add_category_on: (category, data)->
    @store.create_category {
      name: data.name
      parent_id: category.id
    }

  @remove_category: (category)->
    @store.delete_category category

  @update_category: (category, data)->
    @store.update_category category, data