# 章节与课件编辑页面

@ManagerCourseContentsPage = React.createClass
  getInitialState: ->
    chapters: @props.data?.course?.chapters || []

  render: ->
    Chapter = ManagerCourseContentsPage.Chapter

    <div className='manager-course-contents-page'>
      <div className='ui segment'>
      {
        for chapter, idx in @state.chapters
          <Chapter key={idx} data={chapter} idx={idx} />
      }
      </div>
    </div>

  statics:
    Chapter: React.createClass
      getInitialState: ->
        name: @props.data.name
        wares: @props.data?.wares || []
        is_editing_name: false

      render: ->
        Ware = ManagerCourseContentsPage.Ware
        chapter = @props.data

        <div className='chapter'>
          <div className='ch-header'>
            <label>阶段 <span className='idx'>{@props.idx + 1}</span></label>
            <div className='content'>
              <InlineInputEdit value={@state.name} on_submit={@change_name} />
            </div>
          </div>
          <div>
          {
            for ware, idx in @state.wares
              <Ware key={idx} data={ware} idx={idx}/>
          }
          </div>
        </div>

      change_name: (name)->
        @setState
          name: name


    Ware: React.createClass
      getInitialState: ->
        name: @props.data.name

      render: ->
        ware = @props.data

        <div className='ware'>
          <div className='wa-header'>
            <label>小节 <span className='idx'>{@props.idx + 1}</span></label>
            <div className='content'>
              <InlineInputEdit value={@state.name} on_submit={@change_name} />
            </div>
          </div>
        </div>

      change_name: (name)->
        @setState
          name: name