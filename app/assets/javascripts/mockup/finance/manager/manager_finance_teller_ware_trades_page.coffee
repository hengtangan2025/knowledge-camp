@ManagerFinanceTellerWareTradesPage = React.createClass
  getInitialState: ->
    trades: @props.data.trades
    paginate: @props.data.paginate
    hmdm_url: @props.data.hmdm_url

  render: ->
    <div className='manager-bank-teller-wares'>
      <ManagerFinanceTellerWareTradesPage.Table data={@state} page={@} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            number: '业务代码'
            jydm: '关联交易代码'
            jymc: '交易名称'
            xh: '序号'
            input_screen_hmdms: '输入画面'
            response_screen_hmdm: '响应画面'
            compound_screen_hmdm: '结算画面'

          data_set: @props.data.trades.map (x)=>
            jQuery.extend x, {
              input_screen_hmdms:
                <div>
                {
                  for hmdm in x.input_screen_hmdms
                    <ManagerFinanceTellerWareTradesPage.ScreenButton page={@props.page} key={hmdm} hmdm={hmdm} />
                }
                </div>
              response_screen_hmdm:
                if x.response_screen_hmdm?
                  <ManagerFinanceTellerWareTradesPage.ScreenButton page={@props.page} hmdm={x.response_screen_hmdm} />
                else
                  ''
              compound_screen_hmdm:
                if x.compound_screen_hmdm?
                  <ManagerFinanceTellerWareTradesPage.ScreenButton page={@props.page} hmdm={x.compound_screen_hmdm} />
                else
                  ''
            }
          th_classes:
            number: 'collapsing'
            jydm: 'collapsing'
            xh: 'collapsing'
          td_classes:
            jymc: 'collapsing'
          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='关联交易' />
        </div>

    ScreenButton: React.createClass
      render: ->
        <a href='javascript:;' className='ui basic button mini' onClick={@show}>{@props.hmdm}</a>

      show: ->
        jQuery.ajax
          url: @props.page.state.hmdm_url
          data:
            hmdm: @props.hmdm
        .done (res)=>
          screen = res
          jQuery.open_modal <OFCTellerScreen key={screen.hmdm} data={screen} />