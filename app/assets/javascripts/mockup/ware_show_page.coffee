@WareShowPage = React.createClass
  render: ->
    <div className='ware-show-page'>
      <WareShowPage.Contents data={@props.data} />
      <WareShowPage.Comments data={@props.data} />
    </div>

  statics:
    Contents: React.createClass
      getInitialState: ->
        close: false
      render: ->
        klass = new ClassName
          'ware-show-contents': true
          'close': @state.close

        toggle_icon_klass = new ClassName
          'icon': true
          'content': @state.close
          'chevron left': not @state.close

        <div className={klass}>
          <div className='ui segment basic clist'>
            <a className='course-title' href='/mockup/course_show'>
              <i className='icon caret left' />
              {@props.data.course.name}
            </a>
            <CourseWaresList data={@props.data.course} style='narrow' active_ware_id={@props.data.current_ware_id} />
          </div>
          <a href='javascript:;' className='contents-toggle' onClick={@toggle}>
            <i className={toggle_icon_klass} />
          </a>
        </div>

      toggle: ->
        @setState close: !@state.close

    Comments: React.createClass
      getInitialState: ->
        close: false
      render: ->
        klass = new ClassName
          'ware-show-comments': true
          'close': @state.close

        toggle_icon_klass = new ClassName
          'icon': true
          'chevron right': not @state.close
          'comments': @state.close


        <div className={klass}>
          <div className='ui segment basic clist'>
            <CommentsList data={@props.data.comments} />
          </div>
          <a href='javascript:;' className='comments-toggle' onClick={@toggle}>
            <i className={toggle_icon_klass} />
          </a>
        </div>

      toggle: ->
        @setState close: !@state.close