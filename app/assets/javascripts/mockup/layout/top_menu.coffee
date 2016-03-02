@LayoutTopMenu = React.createClass
  render: ->
    <div className='layout-top-menu ui menu top fixed inverted'>
      <div className='ui container'>
        <a className='item logo' href={@props.data.home}>
          Knowledge Camp
        </a>
        {
          for name, url of @props.data.left
            <a key={name} className='item' href={url}>{name}</a>
        }
        
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
        </div>
      </div>
    </div>