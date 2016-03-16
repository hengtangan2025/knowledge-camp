@ManagerTable = React.createClass
  displayName: 'DemoAdminTable'
  render: ->
    <div className='manager-table'>
      <ManagerTable.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        <table className='ui celled table'>
          <ManagerTable.Thead data={@props.data} />
          <ManagerTable.Tbody data={@props.data} />
          <ManagerTable.Tfoot data={@props.data} />
        </table>

    Thead: React.createClass
      render: ->
        <thead><tr>
        {
          for name, text of @props.data.fields
            <th key={name}>{text}</th>
        }
        </tr></thead>

    Tbody: React.createClass
      render: ->
        <tbody>
        {
          for sdata, idx in @props.data.data_set || [{}, {}, {}]
            <ManagerTable.TR key={idx} data={@props.data} sdata={sdata} />
        }
        </tbody>

    TR: React.createClass
      render: ->
        <tr>
        {
          for name, text of @props.data.fields
            content = @props.sdata[name]
            <ManagerTable.TD key={name} content={content} />
        }
        </tr>

    TD: React.createClass
      render: ->
        <td>{@props.content}</td>

    Tfoot: React.createClass
      render: ->
        <tfoot><tr>
          <th colSpan={Object.keys(@props.data.fields).length}>
            <ManagerTable.AddButton data={@props.data.add_button} />
            <Pagination data={@props.data.paginate_data} />
          </th>
        </tr></tfoot>


    # Filter: React.createClass
    #   render: ->
    #     <div ref='filters' className='ui basic segment table-filter'>
    #     {
    #       for key, sdata of @props.data
    #         <div key={key} className="ui floating labeled icon dropdown button mini">
    #           <i className="filter icon"></i>
    #           <span className="text disabled">选择{sdata.text}</span>
    #           <div className="menu">
    #             <div className="header">
    #               <i className="tags icon"></i>
    #               <span>根据{sdata.text}过滤</span>
    #             </div>
    #             {
    #               idx = 0
    #               for value in sdata.values
    #                 <DemoAdminTable.FilterDropDownItem key={idx++} data={value} />
    #             }
    #           </div>
    #         </div>
    #     }
    #     </div>

    #   componentDidMount: ->
    #     jQuery(@refs.filters).find('.ui.dropdown').dropdown()

    # FilterDropDownItem: React.createClass
    #   render: ->
    #     if Array.isArray @props.data
    #       <div className="item">
    #         <i className="dropdown icon"></i>
    #         <span>{@props.data[0]}</span>
    #         <div className='menu'>
    #         {
    #           idx = 0
    #           for value in @props.data[1]
    #             <DemoAdminTable.FilterDropDownItem key={idx++} data={value} />
    #         }
    #         </div>
    #       </div>
    #     else
    #       <div className="item">
    #         <span>{@props.data}</span>
    #       </div>

    # Pagination: React.createClass
    #   render: ->
    #     <div className='ui right floated pagination menu'>
    #       <a className='icon item'><i className='icon left chevron' /></a>
    #       <a className='item active'>1</a>
    #       <a className='item'>2</a>
    #       <a className='item'>3</a>
    #       <a className='icon item'><i className='icon right chevron' /></a>
    #     </div>

    AddButton: React.createClass
      render: ->
        if @props.data?
          <a className='ui labeled icon button green'>
            <i className='icon add' />
            <span>{@props.data}</span>
          </a>
        else
          <div></div>

    # -----------------

    # Company: React.createClass
    #   render: ->
    #     data =
    #       fields:
    #         name: '分公司名称'
    #         address: '地址'
    #         phone: '电话'
    #         director: '负责人'
    #         underlings: '下辖店面'
    #       manage:
    #         underlings: ['list', '设置']
    #       manage_links:
    #         underlings: 'clinic-branch.html'
    #       add_button: '增加分公司'
    #       sample: [
    #         {
    #           name: '苏州分公司'
    #           address: '江苏省苏州市园区娄东路 ** 号'
    #           phone: '0512-12345678'
    #           director: '张仲景'
    #           underlings: '3'
    #         },
    #         {
    #           name: '北京分公司'
    #           address: '北京市朝阳区北苑路 ** 号'
    #           phone: '010-12345678'
    #           director: '孙思邈'
    #           underlings: '2'
    #         }
    #       ]
    #     <DemoAdminTable data={data} />

    # Clinic: React.createClass
    #   render: ->
    #     data = 
    #       fields: 
    #         name: '店面名称'
    #         address: '地址'
    #         phone: '电话'
    #         director: '负责人'
    #         belongs_to: '所属分公司'
    #         beds: '床位数'
    #       manage:
    #         beds: ['list', '设置']
    #       manage_links:
    #         beds: 'clinic-room.html'
    #       add_button: '增加店面'
    #       filters: 
    #         belongs_to:
    #           text: '分公司' 
    #           values: ['苏州分公司', '北京分公司']
    #       sample: [
    #         {
    #           name: '奥体分店'
    #           address: '北京朝阳区惠新西街 ** 号'
    #           phone: '010-12345677'
    #           director: '扁鹊'
    #           belongs_to: '北京分公司'
    #           beds: '100'
    #         },
    #         {
    #           name: '芍药居分店'
    #           address: '北京朝阳区文学馆路 ** 号'
    #           phone: '010-12345676'
    #           director: '钱乙'
    #           belongs_to: '北京分公司'
    #           beds: '150'
    #         }
    #       ]

    #     <DemoAdminTable data={data} />
