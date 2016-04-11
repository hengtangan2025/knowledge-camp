@ManagerFinanceTellerWareScreensPage = React.createClass
  getInitialState: ->
    screens: @props.data.screens
    paginate: @props.data.paginate

  render: ->
    <div className='manager-bank-teller-wares'>
      <ManagerFinanceTellerWareScreensPage.Table data={@state} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            hmdm: '画面代码'
            zds_count: '字段数目'
            ops: '操作'
          data_set: @props.data.screens.map (x)=>
            jQuery.extend x, {
              zds_count: x.zds.length
              ops:
                <div>
                  <a href='javascript:;' target='_blank' className='ui basic button mini' onClick={@preview(x)}>预览</a>
                </div>
            }
          th_classes:
            hmdm: 'collapsing'
            zds: 'zds'
          td_classes:
            ops: 'collapsing'
          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='模拟屏幕清单' />
        </div>

      preview: (screen)->
        (evt)->
          jQuery.open_modal <OFCTellerScreen key={screen.hmdm} data={screen} />