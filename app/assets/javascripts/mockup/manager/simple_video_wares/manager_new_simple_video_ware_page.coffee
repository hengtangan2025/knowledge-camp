@ManagerNewSimpleVideoWarePage = React.createClass
  render: ->
    <div className="manager-new-simple-video-ware-page">
      <ManagerNewSimpleVideoWarePage.Form data={@props.data} />
    </div>

  statics:
    Form: React.createClass
      getInitialState: ->
        errors: {}

      render: ->
        {
          TextInputField
          TextAreaField
          OneVideoUploadField
          Submit
        } = DataForm

        layout =
          label_width: '100px'
          wrapper_width: '50%'

        <div className='ui segment'>
          <SimpleDataForm
            model='simple_video_wares'
            post={@props.data.create_simple_video_ware_url}
            done={@done}
          >
            <TextInputField {...layout} label='视频课件名：' name='name' required />
            <TextAreaField {...layout} label='视频课件简介：' name='desc' rows={10} />
            <OneVideoUploadField {...layout}  label='视频：' name='file_entity_id' />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>
      done: (res)->
        location.href = res.jump_url
