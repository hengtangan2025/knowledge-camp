@CourseShowPage = React.createClass
  render: ->
    <div className='course-show-page'>
      <CourseShowPage.Head data={@props.data} />
    </div>

  statics:
    Head: React.createClass
      render: ->
        <div className='c-head'>
          <div className='ui container'>
            <div className='ui segment basic'>
              <div className='c-info'>
                <div className='image' style={'backgroundImage': "url(#{@props.data.img})"} >
                </div>
                <div className='ops'>
                  <a className='ui button blue large start'>开始学习</a>
                </div>
                <div className='detail'>
                  <h2 className='ui header'>{@props.data.name}</h2>
                  <p className='description'>
                    {@props.data.desc}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>