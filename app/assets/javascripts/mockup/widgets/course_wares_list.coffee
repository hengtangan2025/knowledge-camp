@CourseWaresList = React.createClass
  render: ->
    <div className='course-wares-list'>
    {
      for chapter, idx in @props.data.chapters
        <CourseWaresList.Chapter key={idx} data={chapter} />
    }
    </div>

  statics:
    Chapter: React.createClass
      render: ->
        <div className='chapter'>
          <div className='chname'>
            <div className='pipe' />
            <div className='cwicon' />
            <span className='name'>{@props.data.name}</span>
          </div>

        {
          for ware, idx in @props.data.wares
            icon = 
              switch ware.kind
                when 'video'
                  <i className='kindicon icon play' />
                else
                  <i className='kindicon icon file text outline' />

            tail =
              switch ware.kind
                when 'video'
                  <span>
                    <i className='icon wait' />
                    {ware.time}
                  </span>
                else
                  <span></span>

            <a key={idx} className="ware learned-#{ware.learned}" href='javascript:;'>
              <span className='tail'>{tail}</span>
              <div className='pipe'></div>
              <div className='cwicon'>
              </div>
              {icon}
              <span className='name'>{ware.name}</span>
            </a>
        }
        </div>