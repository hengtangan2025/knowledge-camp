@WareShowPage = React.createClass
  getInitialState: ->
    contents_close: false
    comments_close: false
    ware_data: {
      course_data: @props.data
      function: @UpdateWare
    }
  render: ->
    <div className='ware-show-page'>
      <WareShowPage.Shower data={@state.ware_data} contents_close={@state.contents_close} comments_close={@state.comments_close} />
      <WareShowPage.Contents data={@props.data} close={@state.contents_close} parent={@} />
      <WareShowPage.Comments data={@props.data} close={@state.comments_close} parent={@} />
    </div>

  toggle_contents: ->
    @toggle_changed = true
    @setState contents_close: !@state.contents_close

  toggle_comments: ->
    @toggle_changed = true
    @setState comments_close: !@state.comments_close

  componentDidUpdate: ->
    if @toggle_changed
      @toggle_changed = false
      jQuery(document).trigger 'ware:toggle-changed'

  UpdateWare: (ware_id)->
    for chapter in @state.ware_data.course_data.course.chapters
      for ware in chapter["wares"]
        if ware["id"] == ware_id
          ware["learned"] = "done"
    update_data = @state.ware_data
    @setState ware_data: update_data


  statics:
    Contents: React.createClass
      render: ->
        klass = new ClassName
          'ware-show-contents': true
          'close': @props.close

        toggle_icon_klass = new ClassName
          'icon': true
          'content': @props.close
          'chevron left': not @props.close

        <div className={klass}>
          <div className='ui segment basic clist'>
            <a className='course-title' href={@props.data.course.url}>
              <i className='icon caret left' />
              {@props.data.course.name}
            </a>
            <CourseWaresList data={@props.data.course} function={@props.data.function} style='narrow' active_ware_id={@props.data.ware.id} />
          </div>
          <a href='javascript:;' className='contents-toggle' onClick={@props.parent.toggle_contents}>
            <i className={toggle_icon_klass} />
          </a>
        </div>

    Comments: React.createClass
      render: ->
        klass = new ClassName
          'ware-show-comments': true
          'close': @props.close

        toggle_icon_klass = new ClassName
          'icon': true
          'chevron right': not @props.close
          'comments': @props.close


        <div className={klass}>
          <div className='ui segment basic clist'>
            <CommentsList data={@props.data.comments} />
          </div>
          <a href='javascript:;' className='comments-toggle' onClick={@props.parent.toggle_comments}>
            <i className={toggle_icon_klass} />
          </a>
        </div>

    Shower: React.createClass
      render: ->
        ware = @props.data.course_data.ware
        klass = new ClassName
          'ware-show-shower': true
          'contents-close': @props.contents_close
          'comments-close': @props.comments_close

        <div className={klass}>
          <div className='shower-head'></div>
          <div className='shower-main'>
          {
            switch ware.kind
              when 'video'
                <div className='video-box'>
                  <Ware.Video data={ware} function={@props.data.function} />
                </div>
          }
          </div>
          <div className='shower-foot'></div>
        </div>
