UserDashboardMenu = React.createClass
  render: ->
    <div className="user-dashboard-menu ui vertical menu">
    {
      for item in @props.data.menu
        css = if item.url == @props.data.current_url then "active item" else "item"
        <a className={css} href={item.url} key={item.url}>{item.name}</a>
    }
    </div>

UserDashboardMyNotes = React.createClass
  render: ->
    <div className="user-dashboard-my-notes">
    {
      for item in @props.data
        <div className="note" key={item.id} >
          <div className="title">{item.title}</div>
          <div className="content">{item.content}</div>
          {
            if item.targetable != null
              <div className="from">
                来自
                <a href={item.targetable.url}>{item.targetable.name}</a>
              </div>
          }
        </div>
    }
    </div>

UserDashboardMyQuestions = React.createClass
  render: ->
    <div className="user-dashboard-my-questions">
    {
      for item in @props.data
        <div className="question" key={item.id} >
          <div className="title">{item.title}</div>
          <div className="content">{item.content}</div>
          {
            if item.targetable != null
              <div className="from">
                来自
                <a href={item.targetable.url}>{item.targetable.name}</a>
              </div>
          }
        </div>
    }
    </div>

@UserDashboardMyCoursesPage = React.createClass
  render: ->
    menu_data =
      menu: @props.data.menu,
      current_url: @props.data.current_url

    <div className="user-dashboard-my-courses-page ui container">
      <div className="ui grid">
        <div className="four wide column">
          <UserDashboardMenu data={menu_data} />
        </div>
        <div className="twelve wide column">
          <CoursesPage.Cards data={@props.data.courses} />
          <CoursesPage.Pagination data={@props.data.paginate} />
        </div>
      </div>
    </div>

@UserDashboardMyNotesPage = React.createClass
  render: ->
    menu_data =
      menu: @props.data.menu,
      current_url: @props.data.current_url

    <div className="user-dashboard-my-notes-page ui container">
      <div className="ui grid">
        <div className="four wide column">
          <UserDashboardMenu data={menu_data} />
        </div>
        <div className="twelve wide column">
          <UserDashboardMyNotes data={@props.data.notes} />
          <CoursesPage.Pagination data={@props.data.paginate} />
        </div>
      </div>
    </div>

@UserDashboardMyQuestionsPage = React.createClass
  render: ->
    menu_data =
      menu: @props.data.menu,
      current_url: @props.data.current_url

    <div className="user-dashboard-my-questions-page ui container">
      <div className="ui grid">
        <div className="four wide column">
          <UserDashboardMenu data={menu_data} />
        </div>
        <div className="twelve wide column">
          <UserDashboardMyQuestions data={@props.data.questions} />
          <CoursesPage.Pagination data={@props.data.paginate} />
        </div>
      </div>
    </div>
