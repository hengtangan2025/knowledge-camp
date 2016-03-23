# 章节与课件编辑页面

class DataStore
  constructor: (@page, course)->
    @course = Immutable.fromJS course

  update_chapter: (chapter, data)->
    @course = @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c = c.merge data if c.get('id') is chapter.id
        c

    @reload_page()

  update_ware: (ware, data)->
    @course = @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          wares.map (w)->
            w = w.merge data if w.get('id') is ware.id
            w

    @reload_page()

  delete_ware: (ware)->
    @course = @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          wares.filter (w)->
            w.get('id') != ware.id

    @reload_page()

  move_ware_down: (ware)->
    @course = @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          idx = wares.toJS().map((x)-> x.id).indexOf ware.id
          if idx < wares.size - 1
            w0 = wares.get idx
            w1 = wares.get idx + 1
            wares = wares.set(idx, w1).set(idx + 1, w0) if w0 and w1
          wares

    @reload_page()

  move_ware_up: (ware)->
    @course = @course.update 'chapters', (chapters)->
      chapters.map (c)->
        c.update 'wares', (wares)->
          idx = wares.toJS().map((x)-> x.id).indexOf ware.id
          if idx > 0
            w0 = wares.get idx
            w1 = wares.get idx - 1
            wares = wares.set(idx, w1).set(idx - 1, w0)
          wares

    @reload_page()

  reload_page: ->
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
            <Chapter key={chapter.id} data={chapter} idx={idx} />
        }
        </div>
      </div>
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @, @props.data.course

  statics:
    Chapter: React.createClass
      render: ->
        chapter = @props.data

        <div className='chapter'>
          <div className='ch-header'>
            <label>阶段 <span className='idx'>{@props.idx + 1}</span></label>
            <div className='content'>
              <InlineInputEdit value={chapter.name} on_submit={@change_name} />
            </div>
          </div>
          <div>
          {
            size = chapter.wares.length
            for ware, idx in chapter.wares
              <ManagerCourseContentsPage.Ware key={ware.id} data={ware} idx={idx} wares_size={size}/>
          }
          </div>
        </div>

      change_name: (name)->
        Actions.change_chapter_name(@props.data, name)


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
          <BasicButtons data={buttons_data}/>

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
          yes: @remove

      remove: ->
        jQuery React.findDOMNode @refs.ware
          .hide 400, =>
            Actions.remove_ware @props.data

      move_down: ->
        Actions.move_ware_down @props.data

      move_up: ->
        Actions.move_ware_up @props.data