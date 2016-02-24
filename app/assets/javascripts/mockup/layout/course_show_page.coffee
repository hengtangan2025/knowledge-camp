@CourseShowPage = React.createClass
  render: ->
    <div className='course-show-page'>
      <CourseShowPage.Head data={@props.data} />
      <CourseShowPage.Body data={@props.data} />
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
                  <a className='ui button orange large start'>开始学习</a>
                  <div className='ui left labeled button fav'>
                    <span className='ui basic right pointing label'>128</span>
                    <div className='ui button large olive'>
                      <i className='heart icon' />
                      <span>收藏</span>
                    </div>
                  </div>
                </div>

                <div className='detail'>
                  <h2 className='ui header'>{@props.data.name}</h2>
                  <p className='description'>
                    {@props.data.desc}
                  </p>
                </div>

                <div className='publisher'>
                  <span className='instructor'>讲师：{@props.data.instructor}</span>
                  <span className='published_at'>{@props.data.published_at}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

    Body: React.createClass
      render: ->
        attributes = [
          ['内容量', 'dashboard', @props.data.effort]
          ['价格', 'tag', @props.data.price]
          ['讲师', 'university', <a href='javascript:;'>{@props.data.instructor}</a>]
          ['类别', 'graduation cap', <a href='javascript:;'>{@props.data.subject}</a>]
        ]
        .map (x)->
          {
            name: x[0]
            icon: x[1]
            value: x[2]
          }


        <div className='c-body'>
          <div className='ui container'>
            <div className='ui segment basic grid'>
              <div className='eleven wide column'>
                <div className='ui segment noshadow'>
                  课程详情
                </div>
              </div>

              <div className='five wide column'>
                <div className='ui segment noshadow'>
                  <AttributesPanel data={attributes} />
                </div>
              </div>
            </div>
          </div>
        </div>