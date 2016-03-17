@ManagerNewCoursePage = React.createClass
  render: ->
    <div className='manager-new-course-page'>
      <ManagerNewCoursePage.Form data={@props.data} />
    </div>

  statics:
    Form: React.createClass
      render: ->
        {Form, Field, TextInput, TextArea, Submit} = DataForm

        layout =
          label_width: '100px'
          wrapper_width: '50%'

        <div className='ui segment'>
          <Form onSubmit={@handle_submit}>
            <Field
              {...layout}
              label='课程名：'
            >
              <TextInput name='name' />
            </Field>
            <Field
              {...layout}
              label='课程简介：'
            ><TextArea name='desc' /></Field>
            <Field
              {...layout}
              label=''
            ><Submit text='确定保存' /></Field>
          </Form>
        </div>

      handle_submit: (data)->
        console.log data