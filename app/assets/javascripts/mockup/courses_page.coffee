@CoursesPage = React.createClass
  getInitialState: ->
    courses: @props.data
    
  render: ->
    <div className='courses-page'>
      <CoursesPage.TopCover />
      <div className='ui container'>
        <div className='cards-bg ui segment basic'>
        <CoursesPage.Subjects data={@props.data.course_subjects} />
        <CoursesPage.Cards data={@props.data.courses} />
        <CoursesPage.Pagination data={@props.data.paginate} />
        </div>
      </div>
    </div>

  statics:
    TopCover: React.createClass
      render: ->
        <div className='top-cover' style={'backgroundImage': "url(http://i.teamkn.com/i/LyhMfKq1.png)"}>
          <div className='ui container'>
            <div className='ui segment basic'>
              <h1 className='ui header'>网络公开课</h1>
              <p className='description'>随时参与学习，分享知识，传播文化</p>
            </div>
          </div>
        </div>

    Subjects: React.createClass
      render: ->
        <div className='ui inverted menu course_subjects'>
          {
            for subject in @props.data
              <a className='item course_subject_name' href="/subjects/#{subject.id.$oid}">{subject.name}</a>
          }
        </div>

    Cards: React.createClass
      render: ->
        <div className='ui four link cards'>
          {
            for course, idx in @props.data
              <a key={idx} className='card' href={course.url}>
                <div className='image'>
                  <div className='ig' style={'backgroundImage': "url(#{course.img})"} />
                  <div className='btnoverlay'>
                    <div className='ui button inverted large'>开始学习</div>
                  </div>
                </div>
                <div className='content'>
                  <div className='header'>{course.name}</div>
                  <div className='description'>{course.desc}</div>
                </div>
                <div className="extra content">
                  <span className="right floated">{course.published_at}</span>
                  <span>讲师：{course.instructor}</span>
                </div>
              </a>
          }
        </div>

    Pagination: React.createClass
      render: ->
        <div className='pagination-bar'>
          <Pagination data={@props.data} />
        </div>