@AuthBankSignInPage = React.createClass
  render: ->
    <div className='auth-bank-sign-in-page'>
      <div className='ui container'>
        <div className='ui grid'>
          <div className='eleven wide column' />
          <div className='five wide column'>
            <div className='ui segment'>
              <div className='head'>
                <span className='sign-in link'>用户登录</span>
              </div>
              <SignInForm submit_url={''} jump={''} />
            </div>
          </div>
        </div>
      </div>
    </div>