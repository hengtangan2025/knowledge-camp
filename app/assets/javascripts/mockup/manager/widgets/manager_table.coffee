@ManagerTable = React.createClass
  displayName: 'DemoAdminTable'
  render: ->
    <div className='manager-table'>
      <h4 className='ui header'>
        <i className='icon list' />
        <div className='content'>{@props.title}数据列表</div>
      </h4>

      {
        if @props.data.filters?
          <ManagerTable.Filter data={@props.data.filters} />
      }
      <ManagerTable.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        <table className='ui celled table small'>
          <ManagerTable.Thead data={@props.data} />
          <ManagerTable.Tbody data={@props.data} />
          <ManagerTable.Tfoot data={@props.data} />
        </table>

    Thead: React.createClass
      render: ->
        <thead><tr>
        {
          for name, text of @props.data.fields
            klass = @props.data.th_classes?[name] || ''
            <th key={name} className={klass}>{text}</th>
        }
        </tr></thead>

    Tbody: React.createClass
      render: ->
        <tbody>
        {
          for sdata, idx in @props.data.data_set || [{}, {}, {}]
            if not sdata.id?
              console.warn '请在 table_data.data_set 中为表格数据对象设置 id 属性'
            <ManagerTable.TR key={sdata.id} data={@props.data} sdata={sdata} />
        }
        </tbody>

    TR: React.createClass
      render: ->
        <tr>
        {
          for name, text of @props.data.fields
            content = @props.sdata[name]
            klass = @props.data.td_classes?[name] || ''
            <td key={name} className={klass}>{content}</td>
        }
        </tr>

    Tfoot: React.createClass
      render: ->
        <tfoot><tr>
          <th colSpan={Object.keys(@props.data.fields).length}>
          {
            if @props.data.paginate?
              <PaginationTextInfo data={@props.data.paginate} /> 
              <Pagination data={@props.data.paginate} />
          }
          </th>
        </tr></tfoot>


    Filter: React.createClass
      render: ->
        <div ref='filters' className='table-filters'>
        {
          for key, sdata of @props.data
            {#<ManagerTable.Filter.IconDropDown key={key} sdata={sdata} />}
            <ManagerTable.Filter.SelectionDropDown key={key} sdata={sdata} />
        }
        </div>

      componentDidMount: ->
        jQuery(React.findDOMNode @refs.filters).find('.ui.dropdown').dropdown()

      statics:
        IconDropDown: React.createClass
          render: ->
            sdata = @props.sdata

            <div className='ui floating labeled icon dropdown button mini'>
              <i className='filter icon'></i>
              <span className='text disabled'>选择{sdata.text}</span>
              <div className='menu'>
                <div className='header'>
                  <i className='tags icon'></i>
                  <span>根据{sdata.text}过滤</span>
                </div>
                {
                  for value, idx in sdata.values
                    <ManagerTable.FilterDropDownItem key={idx} data={value} />
                }
              </div>
            </div>

        SelectionDropDown: React.createClass
          render: ->
            sdata = @props.sdata

            <div className='ui selection dropdown'>
              <i className='dropdown icon'></i>
              <span className='text default'>选择{sdata.text}</span>
              <div className='menu'>
                {
                  for value, idx in sdata.values
                    <ManagerTable.FilterDropDownItem key={idx} data={value} />
                }
              </div>
            </div>

    FilterDropDownItem: React.createClass
      render: ->
        if Array.isArray @props.data
          <div className='item'>
            <i className='dropdown icon'></i>
            <span>{@props.data[0]}</span>
            <div className='menu'>
            {
              for value, idx in @props.data[1]
                <ManagerTable.FilterDropDownItem key={idx} data={value} />
            }
            </div>
          </div>
        else
          <div className='item'>
            <span>{@props.data}</span>
          </div>