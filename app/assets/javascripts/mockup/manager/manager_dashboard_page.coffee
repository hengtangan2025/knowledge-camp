@ManagerDashboardPage = React.createClass
  displayName: 'ManagerDashboardPage'
  render: ->
    <div className='manager-dashboard-page'>
    {
      for scene, idx in @props.data.scenes
        <div key={idx} className=''>
          <h4 className=''><i className='icon list' /> {scene.name}</h4>
          <div className='manager-funcs'>
          {
            for func, idx in scene.funcs
              <a key={idx} href={func.url} className='func'>
                <i className="icon #{func.icon}" />
                <span className='text'>{func.name}</span>
              </a>
          }
          </div>
        </div>
    }
    </div>