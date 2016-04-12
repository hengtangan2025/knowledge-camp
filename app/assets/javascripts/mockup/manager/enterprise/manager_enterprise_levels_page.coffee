@ManagerEnterpriseLevelsPage = React.createClass
  getInitialState: ->
    levels: @props.data.levels

  render: ->
    <div className='manager-courses-page'>
    {
      if @state.levels.length is 0
        data =
          header: '级别设置'
          desc: '还没有创建任何级别'
          init_action: <ManagerEnterpriseLevelsPage.CreateBtn data={@props.data} page={@} />
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerEnterpriseLevelsPage.CreateBtn data={@props.data} page={@} />
          <ManagerEnterpriseLevelsPage.Table data={@state.levels} page={@} />
        </div>
    }
    </div>

  add_level: (level)->
    levels = Immutable.fromJS @state.levels
    levels = levels.push level
    @setState levels: levels.toJS()

  update_level: (level)->
    levels = Immutable.fromJS @state.levels
    levels = levels.map (x)->
      x = x.merge level if x.get('id') is level.id
      x
    @setState levels: levels.toJS()

  delete_level: (level)->
    levels = Immutable.fromJS @state.levels
    levels = levels.filter (x)->
      x.get('id') != level.id
    @setState levels: levels.toJS()

  statics:
    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href='javascript:;' onClick={@show_modal}>
          <i className='icon plus' />
          创建级别
        </a>

      show_modal: ->
        params =
          url: @props.data.create_url
          title: '创建级别'
          page: @props.page

        jQuery.open_modal <ManagerEnterpriseLevelsPage.Form {...params} />

    Form: React.createClass
      render: ->
        {
          TextInputField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        <div>
          <h3 className='ui header'>{@props.title}</h3>
          <SimpleDataForm
            model='level'
            post={@props.url}
            done={@done}  
          >
            <TextInputField {...layout} label='级别名称：' name='name' required />
            <TextInputField {...layout} label='级别代号：' name='number' required />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>

      done: (data)->
        @props.page.add_level data.level
        @state.close()

    UpdateForm: React.createClass
      render: ->
        {
          TextInputField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        <div>
          <h3 className='ui header'>{@props.title}</h3>
          <SimpleDataForm
            model='level'
            put={@props.url}
            done={@done}
            data={@props.data}  
          >
            <TextInputField {...layout} label='级别名称：' name='name' required />
            <TextInputField {...layout} label='级别代号：' name='number' required />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>

      done: (data)->
        @props.page.update_level data.level
        @state.close()

    Table: React.createClass
      render: ->
        table_data = {
          fields:
            number: '级别代号'
            name: '级别名称'
            levels: '级别配置'
            ops: '操作'
          data_set: @props.data.map (x)=>
            id: x.id
            number: x.number
            name: x.name
            ops:
              <div>
                <a href='javascript:;' className='ui basic button blue mini' onClick={@edit(x)}>
                  <i className='icon edit' /> 修改
                </a>
                <a href='javascript:;' className='ui basic button red mini' onClick={@delete(x)}>
                  <i className='icon trash' /> 删除
                </a>
              </div>

          th_classes: {
            number: 'collapsing'
          }
          td_classes: {
            ops: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='级别设置' />
        </div>

      edit: (level)->
        =>
          params =
            url: level.update_url
            title: '修改级别信息'
            page: @props.page
            data: level

          jQuery.open_modal <ManagerEnterpriseLevelsPage.UpdateForm {...params} />

      delete: (level)->
        =>
          jQuery.modal_confirm
            text: '确定要删除吗？'
            yes: =>
              jQuery.ajax
                url: level.delete_url
              .done =>
                @props.page.delete_level level