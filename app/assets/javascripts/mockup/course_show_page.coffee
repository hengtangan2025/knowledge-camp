@CourseShowPage = React.createClass
  getInitialState: ->
    favorite_bar_data: @props.data

  update_favorite_bar_data:(num,str)->
    data = @state.favorite_bar_data
    data.favorite_bar_data.num = num
    data.favorite_bar_data.str = str
    @setState
      favorite_bar_data: data

  render: ->
    <div className='course-show-page'>
      <CourseShowPage.Head data={@state.favorite_bar_data} function={@update_favorite_bar_data}/>
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
                  <a className='ui button blue large start'>开始学习</a>
                  <CourseShowPage.FavoriteBar data={@props.data.favorite_bar_data} function={@props.function}/>                  
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
          ['类别', 'graduation cap', <CourseShowPage.Subjects data={@props.data.subjects} />]
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
                <div className='ui segment noshadow contents'>
                  <h3 className='ui header'>课程目录</h3>
                  <CourseWaresList data={@props.data} />
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

    Subjects: React.createClass
      render: ->
        <div className='subjects'>
        { 
          for subject, idx in @props.data
            <div key={idx} className='subject'>
              <a href={subject.url}>{subject.name}</a>
            </div>
            
        }
        </div>

    FavoriteBar: React.createClass
      render: ->
        <div className='ui left labeled button fav'>
          <span className='ui basic right pointing label data-num'>
            <p className='plus'>+1</p>
            <p>{@props.data.num}</p>
          </span>
          <div className='ui button large olive favorite-btn'>
            <i className='heart icon' />
            <span>{@props.data.str}</span>
          </div>
        </div>

      componentDidMount: ->
        jQuery(".plus").css("display", "none")
        if @props.data.str == "取消收藏"
          jQuery(".heart.icon").css("color", "red")

        jQuery(".course-show-page .favorite-btn").on "click", ()=>
          jQuery.ajax
            url:"/courses/exchange_favorite_course",
            method: "POST",
            data: 
             course_id: @props.data.course_id
          .success (msg)=>
            @props.function(msg.count,msg.str)
            if msg.str == "取消收藏"
              jQuery(".heart.icon").css("color", "red")
            else
              jQuery(".heart.icon").css("color", "#F0F5D1")
          .error ()->
            console.log "failure"
          
          

