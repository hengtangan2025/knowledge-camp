@ManagerCsubjectsPage = React.createClass
  getInitialState: ->
    subjects: @props.data.subjects || []

  render: ->
    <div className='manager-csubjects-page'>
    {
      if @state.subjects.length is 0
        data =
          header: '课程分类'
          desc: '还没有创建任何课程分类'
          init_action: ''
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerCsubjectsPage.Table subjects={@state.subjects} parent={@}/>
          <div className='ui segment btns'>
            <a className='ui button green mini' href='javascript:;' onClick={@create_root_subject}>
              <i className='icon plus' />
              增加新分类
            </a>
          </div>
        </div>
    }
    </div>

  create_root_subject: ->
    s = Immutable.fromJS @state.subjects
    s = s.push
      id: Math.random()
      name: '新分类'
      slug: 'xin-fen-lei'
      courses_count: 0

    @setState subjects: s.toJS()

  create_subject_on: (subject)->
    =>
      s = Immutable.fromJS @state.subjects

      _r = (x)->
        if x.get('id') == subject.id
          x.update 'children', (children)->
            c = if children? then children else Immutable.fromJS([])
            c = c.push 
              id: Math.random()
              name: '新分类'
              slug: 'xin-fen-lei'
              courses_count: 0
            c
        else
          x.update 'children', (children)->
            c = if children? then children else Immutable.fromJS([])
            c.map (cx)->
              _r(cx)

      s = s.map (x)->
        _r(x)

      @setState subjects: s.toJS()

  statics:
    Table: React.createClass
      render: ->
        flatten_data = jQuery.flatten_tree @props.subjects, 'children'

        table_data = {
          fields:
            name: '分类名称'
            add_child: ''
            slug: '链接名称'
            courses_count: '课程数目'
          data_set: flatten_data.map (x)=> 
            name_klass = new ClassName
              'tree-item': true
              'level-last': x._level_last

            {
              id: x.id
              name:
                <div className={name_klass}>
                  <div className='tree-pd'>
                  {
                    for idx in [0...x._depth]
                      <div key={idx} className='line'></div>
                  }
                  </div>
                  <div className='item-name'>
                    <InlineInputEdit value={x.name} on_submit={@update_subject(x)} />
                  </div>
                </div>
              slug:
                <InlineInputEdit value={x.slug} on_submit={@update_subject(x)} />
              courses_count: x.courses_count
              add_child:
                <a href='javascript:;' className='ui green basic button mini' onClick={@props.parent.create_subject_on(x)}>
                  <i className='icon plus' />
                  增加子分类
                </a>
            }
          th_classes: {
            courses_count: 'collapsing'
          }
          td_classes: {
            slug: 'slug'
            actions: 'collapsing'
            add_child: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='课程分类' />
        </div>

      update_subject: (x)->
        ->
          console.log x