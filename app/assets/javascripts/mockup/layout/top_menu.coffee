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
        </div>
      </div>
    </div>

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
