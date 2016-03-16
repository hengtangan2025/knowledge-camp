@ManagerCoursesPage = React.createClass
  render: ->
    <div className='manager-courses-page'>
    {
      if @props.data.courses.length is 0
        data =
          header: '开课管理'
          desc: '还没有创建任何课程'
          init_action:
            <a className='ui button green'>
              <i className='icon plus' />
              创建课程
            </a>

        <ManagerFuncNotReady data={data} />
      else
    #     data =
    #       fields:
    #         name: '分公司名称'
    #         address: '地址'
    #         phone: '电话'
    #         director: '负责人'
    #         underlings: '下辖店面'
    #       manage:
    #         underlings: ['list', '设置']
    #       manage_links:
    #         underlings: 'clinic-branch.html'
    #       add_button: '增加分公司'
    #       sample: [
    #         {
    #           name: '苏州分公司'
    #           address: '江苏省苏州市园区娄东路 ** 号'
    #           phone: '0512-12345678'
    #           director: '张仲景'
    #           underlings: '3'
    #         },
    #         {
    #           name: '北京分公司'
    #           address: '北京市朝阳区北苑路 ** 号'
    #           phone: '010-12345678'
    #           director: '孙思邈'
    #           underlings: '2'
    #         }
    #       ]

        table_data = {
          fields:
            name: '课程名称'
            instructor: '讲师'
            updated_at: '更新时间'
            actions: '操作'
          data_set: @props.data.courses.map (x)->
            {
              name: x.name
              instructor: x.instructor
              updated_at: x.updated_at
              actions: 
                <a className='ui button mini green' href='javascript:;'>
                  <i className='icon edit' />
                  编辑
                </a>
            }
          add_button: '增加'
          paginate_data:
            total_pages: 5
            current_page: 2
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} />
        </div>
    }
    </div>
