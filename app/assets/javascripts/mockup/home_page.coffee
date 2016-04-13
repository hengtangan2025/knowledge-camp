@HomePage = React.createClass
  getInitialState: ->
    current_user: @props.data.current_user
  render: ->
    <div>
      <LayoutNoPage name='首页' />
      <div className='ui container'>
        <div className='ui segment basic'>
          {
            if @state.current_user?
              <a className='ui button green' href={@props.data.manager_url}>访问后台</a>
            else
              <a className='ui button blue' href={@props.data.manager_sign_in_url}>后台登录</a>
          }
        </div>
      </div>
    </div>