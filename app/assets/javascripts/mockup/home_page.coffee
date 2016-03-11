@HomePage = React.createClass
  render: ->
    <div>
      <LayoutNoPage name='首页' />
      <div className='ui container'>
        <div className='ui segment basic'>
          <a className='ui button blue' href={@props.data.manager_sign_in_url}>后台登录</a>
        </div>
      </div>
    </div>