@LayoutManagerTopMenu = React.createClass
  render: ->
    <div className='layout-top-menu manager ui menu top fixed'>
      <div className='right menu'>
      {
        if @props.current_user_data
          user = @props.current_user_data
          [
            <a key='avatar' className='item avatar' href='javascript:;'>
              <img src={user.avatar.url} />
            </a>
            <a key='name' className='item' href='javascript:;'>{user.name}</a>
            <a key='sign-out' className='item' onClick={@do_sign_out}>登出</a>
          ]
      }
      </div>
    </div>

  do_sign_out: ->
    jQuery.ajax
      url: @props.data.sign_out_url
      type: 'delete'
    .done =>
      location.href = @props.data.sign_out_to_url


@LayoutTopMenu = React.createClass
  render: ->
    <div className='layout-top-menu ui menu top fixed'>
      <div className='ui container'>
        <a className='item logo' href={@props.data.logo.url}>
          <div className='logo-i' style={'backgroundImage': "url(#{@props.data.logo.image})"} />
        </a>

        <LayoutTopMenu.NestedItems klass='left menu' data={@props.data.nav_items} />
        
        <div className='right menu'>
          <div className='item'>
            <div className='ui icon input'>
              <input type='text' placeholder='搜索课程…' />
              <i className='search link icon'></i>
            </div>
          </div>
          {
            for name, url of @props.data.right
              <a key={name} className='item' href={url}>{name}</a>
          }

          {
            if @props.current_user_data
              user = @props.current_user_data
              [
                <a key='avatar' className='item' href='javascript:;'>
                  <img src={user.avatar.url} />
                </a>
                <a key='name' className='item' href='javascript:;'>{user.name}</a>
                <a key='sign-out' className='item' onClick={@do_sign_out}>登出</a>
              ]
          }
        </div>
      </div>
    </div>

  do_sign_out: ->
    jQuery.ajax
      url: @props.data.sign_out_url
      type: 'delete'
    .done ->
      location.reload()

  statics:
    NestedItems: React.createClass
      render: ->
        <div className={@props.klass}>
        {
          for item, idx in @props.data
            if not item.sub_items?
              <a key={idx} className='item' href={item.url}>{item.name}</a>
            else
              <div key={idx} className='ui simple dropdown item'>
                <span href={item.url}>{item.name}</span>
                <i className='icon dropdown' />
                <LayoutTopMenu.NestedItems klass='menu' data={item.sub_items} />
              </div>
        }
        </div>
