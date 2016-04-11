@ManagerFinanceTellerWarePreviewPage = React.createClass
  getInitialState: ->
    ware: @props.data
  render: ->
    data = 
      baseinfo: 
        number: @state.ware.number
        name: @state.ware.name
        linked_flows: []
        descs: {}
        gainian: {}
      actioninfo:
        actions: @state.ware.actions
        action_desc: []
        screens: []
        screens_desc: []


    <div>
      <TellerCourseWare data={data} />
    </div>