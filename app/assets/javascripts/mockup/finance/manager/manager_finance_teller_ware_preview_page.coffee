@ManagerFinanceTellerWarePreviewPage = React.createClass
  getInitialState: ->
    ware: @props.data
  render: ->
    data = 
      baseinfo: 
        number: @state.ware.number
        name: @state.ware.name
        desc: @state.ware.desc

        linked_flows: []
        gainian: {}
      actioninfo:
        actions: @state.ware.actions

    <div>
      <TellerCourseWare data={data} />
    </div>