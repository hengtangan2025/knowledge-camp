@Pagination = React.createClass
  render: ->
    <div className="ui pagination menu">
      <a className='item'><i className='icon step backward' /></a>
      <a className='item'><i className='icon chevron left' /></a>
      <a className="active item">1</a>
      <a className="item">2</a>
      <div className="disabled item">...</div>
      <a className="item">10</a>
      <a className="item">11</a>
      <a className="item">12</a>
      <a className='item'><i className='icon chevron right' /></a>
      <a className='item'><i className='icon step forward' /></a>
    </div>