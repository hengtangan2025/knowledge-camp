@ManagerFinanceTellerWarePreviewPage = React.createClass
  getInitialState: ->
    ware: @props.data
  render: ->
    data = 
      baseinfo: 
        number: @state.ware.number
        name: @state.ware.name
        desc: @state.ware.desc
        business_kind_str: @state.ware.business_kind_str
        relative_wares: @state.ware.relative_wares || []
      actioninfo:
        actions: @state.ware.actions

    <div>
      <TellerCourseWare data={data} />
    </div>