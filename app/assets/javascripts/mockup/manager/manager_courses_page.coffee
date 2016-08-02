@ManagerCoursesPage = React.createClass
  getInitialState: ->
    courses_data_refresh: @props.data

  render: ->
    <div className='manager-courses-page'>
    {
      subjects = @props.data.filter_subjects || []
      tdp = new TreeArrayParser subjects
      flatten_subjects = tdp.get_depth_first_array()
      courses_data = 
        all_course_data: @state.courses_data_refresh
        flatten_subjects: flatten_subjects
        filter_ajax_function: @filter_courses_from_subjec

      if @props.data.courses.length is 0
        data =
          header: '开课管理'
          desc: '还没有创建任何课程'
          init_action: <ManagerCoursesPage.CreateBtn data={@props.data} />
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerCoursesPage.CreateBtn data={@props.data} />
          <ManagerCoursesPage.Table data={courses_data} />
        </div>
    }
    </div>
  
  # 发起 ajax 查询指定课程类型下的课程
  filter_courses_from_subjec: (url_to_filter, subject_id)->
    jQuery.ajax
      url: url_to_filter,
      method: "GET",
      data: 
        subject_id: subject_id
    .success (msg)=>
      @setState
        courses_data_refresh: msg
    .error ()->
      console.log "failure"

  statics:
    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href={@props.data.new_course_url}>
          <i className='icon plus' />
          创建课程
        </a>

    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '课程名称'
            instructor: '讲师'
            updated_at: '更新时间'
            actions: '操作'
          data_set: @props.data.all_course_data.courses.map (x)->
            {
              id: x.id
              name: x.name
              instructor: x.instructor
              updated_at: x.updated_at
              actions: 
                <div>
                  <a className='ui button mini blue basic' href={x.manager_contents_url}>
                    <i className='icon pencil' />
                    内容编排
                  </a>
                  <a className='ui button mini blue basic' href="/manager/courses/#{x.id}/edit_subject">
                    <i className='icon pencil' />
                    编辑课程类型
                  </a>
                </div>
            }

          filters: 
            subjects:
              text: '课程分类' 
              values: @props.data.flatten_subjects.map (x)=> 
                <div className='selection-tree'>
                  <ManagerCoursesPage.TreeItemTD data={x} root={@props.data.filter_ajax_function}/>
                </div>

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }

          paginate: @props.data.all_course_data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='开课管理' />
        </div>

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
          <div className='item-name' onClick={@filter_course(x.search_courses_url, x.id)}>
            <a href='javascript:void(0)'>{x.name}</a>
          </div>
        </div>

      filter_course: (filter_url, subject_id)->
        =>
          @props.root(filter_url, subject_id)
