@WareShowPage = React.createClass
  render: ->
    <div className='ware-show-page'>
      <WareShowPage.Comments data={@props.data} />
    </div>

  statics:
    Comments: React.createClass
      getInitialState: ->
        close: false
      render: ->
        klass = new ClassName
          'ware-show-comments': true
          'close': @state.close

        <div className={klass}>
          <div className='ui segment basic clist'>
            <CommentsList data={@props.data.comments} />
          </div>
          <a href='javascript:;' className='comments-toggle' onClick={@toggle}>
            <i className='icon sidebar' />
          </a>
        </div>

      toggle: ->
        @setState close: !@state.close