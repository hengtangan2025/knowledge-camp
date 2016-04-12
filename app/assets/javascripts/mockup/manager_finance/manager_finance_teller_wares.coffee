@ManagerFinanceTellerWaresPage = React.createClass
  displayName: 'ManagerFinanceTellerWaresPage'
  getInitialState: ->
    wares: @props.data.wares
    paginate: @props.data.paginate

  render: ->
    <div className='manager-bank-teller-wares'>
      <div className='wares'>
        <div className='ui cards'>
        {
          for ware in @state.wares
            <ManagerFinanceTellerWaresPage.WareCard key={ware.id} data={ware} />
        }
        </div>
      </div>
    </div>

  statics:
    WareCard: React.createClass
      render: ->
        ware = @props.data
        <div className='card ware'>
          <div className='content'>
            <div className='right floated mini ui image'>
              <div className='ic'>
                <i className='icon rmb' />
              </div>
            </div>
            <div className='header number'>
              {ware.number}
            </div>
            <div className='meta name'>
              {ware.name}
            </div>
          </div>
          <div className='extra content'>
            <a className='ui basic button fluid pill' href={ware.manage_url}>
              管　理
            </a>
          </div>
        </div>
