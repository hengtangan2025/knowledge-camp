@SignInPage = React.createClass
  render: ->
    <div className='sign-in-page'>
      <div className='ui container'>
        <div className='ui segment nomtop basic centered grid'>
          <div className='five wide column'>
            <SignHead data={@props.data} is_sign_up={false} />
            <SignInForm submit_url={@props.data.submit_url} />
          </div>
        </div>
      </div>
    </div>

@SignUpPage = React.createClass
  render: ->
    <div className='sign-in-page'>
      <div className='ui container'>
        <div className='ui segment nomtop basic centered grid'>
          <div className='five wide column'>
            <SignHead data={@props.data} is_sign_up={true} />
            <SignUpForm submit_url={@props.data.submit_url} />
          </div>
        </div>
      </div>
    </div>


@ManagerSignInPage = React.createClass
  render: ->
    <div className='sign-in-page'>
      <div className='ui container'>
        <div className='ui segment nomtop basic centered grid'>
          <div className='five wide column'>
            <div className='head'>
              <span className='sign-in link'>管理员登录</span>
            </div>
            <SignInForm submit_url={@props.data.submit_url} jump={@props.data.manager_home_url} />
          </div>
        </div>
      </div>
    </div>


SignHead = React.createClass
  render: ->
    sign_in_url = @props.data.sign_in_url
    sign_up_url = @props.data.sign_up_url

    if @props.is_sign_up
      <div className='head'>
        <a className='sign-in link' href={sign_in_url}>登录</a>
        <a className='sign-up link active' href={sign_up_url}>注册</a>
      </div>
    else
      <div className='head'>
        <a className='sign-in link active' href={sign_in_url}>登录</a>
        <a className='sign-up link' href={sign_up_url}>注册</a>
      </div>