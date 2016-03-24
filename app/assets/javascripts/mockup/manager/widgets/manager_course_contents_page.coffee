@ManagerCourseContentsPage = React.createClass
  getInitialState: ->
    course: @props.data.course

  render: ->
    Chapter = ManagerCourseContentsPage.Chapter
    course = @state.course

    <div className='manager-course-contents-page'>
      <div className='ui segment'>
        <div className='chapters'>
          {
            for chapter, idx in course.chapters
              <Chapter key={chapter.id} data={chapter} idx={idx} chapters_size={course.chapters.length} />
          }
          {
            if course.chapters.length is 0
              <div className='ui info message'>还没有添加任何章节</div>
          }
          <div className='ch-actions'>
            {
              if @state.creating_chapter
                <div className='ui active small inline loader'></div>
              else
                <a href='javascript:;' onClick={@add_chapter}><i className='icon plus' /> 添加阶段</a>
            }
          </div>
          <div>
            <a className='ui button green' href={@props.data.manager_courses_url}>
              <i className='icon check' /> 保存课程
            </a>
          </div>
        </div>
      </div>
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @, @props.data.course

  add_chapter: ->
    Actions.add_chapter '未命名章节'

  statics:
    Chapter: React.createClass
      render: ->
        chapter = @props.data

        buttons_data = [
          {
            disabled: @props.idx is 0
            icon: 'arrow up'
            onclick: @move_up
            title: '上移'
          },
          {
            disabled: @props.idx is @props.chapters_size - 1
            icon: 'arrow down'
            onclick: @move_down
            title: '下移'
          },
          {
            icon: 'remove'
            onclick: @remove_confirm
            title: '删除'
          }
        ]

        buttons =
          <BasicButtons data={buttons_data} />

        <div className='chapter' ref='chapter'>
          <div className='ch-header'>
            <label>第 <span className='idx'>{@props.idx + 1}</span> 章</label>
            <div className='content'>
              <InlineInputEdit value={chapter.name} on_submit={@change_name} />
            </div>
            {buttons}
          </div>
          <div className='wares'>
          {
            size = chapter.wares.length
            for ware, idx in chapter.wares
              <ManagerCourseContentsPage.Ware key={ware.id} data={ware} idx={idx} wares_size={size}/>
          }
          </div>
          <div className='actions'>
            <a href='javascript:;' ref='add_ware'><i className='icon plus' /> 添加小节</a>
            <div className="ui popup basic hidden" ref='add_ware_popup'>
              <a href='javascript:;' onClick={window.CreateWare.video(chapter)}><i className='icon video' /> 上传视频</a>
            </div>
          </div>
        </div>

      componentDidMount: ->
        jQuery React.findDOMNode @refs.add_ware
          .popup
            popup: jQuery React.findDOMNode @refs.add_ware_popup
            position: 'top right'
            hoverable: true
            # delay:
            #   hide: 300

      change_name: (name)->
        Actions.change_chapter_name(@props.data, name)

      remove_confirm: ->
        jQuery.modal_confirm
          text: '确定要删除吗？'
          yes: =>
            jQuery React.findDOMNode @refs.chapter
              .hide 400, =>
                Actions.remove_chapter @props.data

      move_up: ->
        Actions.move_chapter_up @props.data

      move_down: ->
        Actions.move_chapter_down @props.data


    Ware: React.createClass
      render: ->
        ware = @props.data

        buttons_data = [
          {
            disabled: @props.idx is 0
            icon: 'arrow up'
            onclick: @move_up
            title: '上移'
          },
          {
            disabled: @props.idx is @props.wares_size - 1
            icon: 'arrow down'
            onclick: @move_down
            title: '下移'
          },
          {
            icon: 'remove'
            onclick: @remove_confirm
            title: '删除'
          }
        ]

        buttons =
          <BasicButtons data={buttons_data} />

        <div className='ware' ref='ware'>
          <div className='wa-header'>
            <label>小节 <span className='idx'>{@props.idx + 1}</span></label>
            <div className='content'>
              <InlineInputEdit value={ware.name} on_submit={@change_name} />
            </div>
            {buttons}
          </div>
        </div>

      change_name: (name)->
        Actions.change_ware_name @props.data, name

      remove_confirm: ->
        jQuery.modal_confirm
          text: '确定要删除吗？'
          yes: =>
            jQuery React.findDOMNode @refs.ware
              .hide 400, =>
                Actions.remove_ware @props.data

      move_down: ->
        Actions.move_ware_down @props.data

      move_up: ->
        Actions.move_ware_up @props.data




# -------------------



# 章节与课件编辑页面

Util =
  exange: (immutable_arr, idx0, idx1)->
    x0 = immutable_arr.get idx0
    x1 = immutable_arr.get idx1
    if x0? and x1?
      immutable_arr.set(idx0, x1).set(idx1, x0)
    else
      immutable_arr

  index_of: (immutable_arr, item)->
    immutable_arr.toJS()
      .map (x)-> x.id
      .indexOf item.id

  move_up: (immutable_arr, item)->
    idx = Util.index_of immutable_arr, item
    if idx > 0
      Util.exange immutable_arr, idx, idx - 1
    else
      immutable_arr

  move_down: (immutable_arr, item)->
    idx = Util.index_of immutable_arr, item
    if idx < immutable_arr.size - 1 and idx > -1
      Util.exange immutable_arr, idx, idx + 1
    else
      immutable_arr

  delete: (immutable_arr, item)->
    immutable_arr.filter (x)->
      x.get('id') != item.id


class DataStore
  constructor: (@page, course)->
    @course = Immutable.fromJS course

  update_chapter: (chapter, data)->
    @reload_page @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c = c.merge data if c.get('id') is chapter.id
        c

  update_ware: (ware, data)->
    @reload_page @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          wares.map (w)->
            w = w.merge data if w.get('id') is ware.id
            w

  delete_ware: (ware)->
    @reload_page @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          Util.delete wares, ware

  move_ware_down: (ware)->
    @reload_page @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          Util.move_down wares, ware

  move_ware_up: (ware)->
    @reload_page @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          Util.move_up wares, ware

  create_chapter: (data)->
    @page.setState creating_chapter: true

    jQuery.ajax
      type: 'POST'
      url: @page.props.data.manager_create_chapter_url
      data: data
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        chapters.push Immutable.fromJS res
    .always =>
      @page.setState creating_chapter: false

  delete_chapter: (chapter)->
    @reload_page @course.update 'chapters', (chapters)->
      Util.delete chapters, chapter

  move_chapter_down: (chapter)->
    @reload_page @course.update 'chapters', (chapters)->
      Util.move_down chapters, chapter

  move_chapter_up: (chapter)->
    @reload_page @course.update 'chapters', (chapters)->
      Util.move_up chapters, chapter

  reload_page: (course)->
    @course = course
    @page.setState
      course: @course.toJS()
      update: true



Actions = class
  @set_store: (store)->
    @store = store

  @change_chapter_name: (chapter, name)->
    @store.update_chapter chapter,
      name: name

  @change_ware_name: (ware, name)->
    @store.update_ware ware,
      name: name

  @remove_ware: (ware)->
    @store.delete_ware ware

  @move_ware_down: (ware)->
    @store.move_ware_down ware

  @move_ware_up: (ware)->
    @store.move_ware_up ware

  @add_chapter: (name)->
    @store.create_chapter
      name: name

  @remove_chapter: (chapter)->
    @store.delete_chapter chapter

  @move_chapter_up: (chapter)->
    @store.move_chapter_up chapter

  @move_chapter_down: (chapter)->
    @store.move_chapter_down chapter