@ManagerSimpleVideoWaresPage = React.createClass
  render: ->
    <div className="manager-simple-video-wares-page">
    {
      if @props.data.simple_video_wares.length is 0
        data =
          header: '视频课件管理'
          desc: '还没有创建任何视频课件'
          init_action: <ManagerSimpleVideoWaresPage.CreateBtn data={@props.data} />
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerSimpleVideoWaresPage.CreateBtn data={@props.data} />
          <ManagerSimpleVideoWaresPage.Table data={@props.data} />
        </div>
    }
    </div>

  statics:
    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href={@props.data.new_simple_video_wares_url}>
          <i className='icon plus' />
          创建视频课件
        </a>

    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '视频课件名称'
            business_categories: '所属业务类别'
            actions: '操作'
          data_set: @props.data.simple_video_wares.map (x)->
            {
              id: x.id
              name: x.name
              business_categories: x.business_categories
              actions:
                <div>
                  <a className='ui button mini blue basic' href={x.manager_edit_base_info_url}>
                    <i className='icon pencil' />
                    基本内容修改
                  </a>
                  <a className='ui button mini blue basic' href={x.manager_edit_business_categories_url}>
                    <i className='icon pencil' />
                    业务类别修改
                  </a>
                </div>
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='视频课件管理' />
        </div>
