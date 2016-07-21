@ManagerEditSubjectPage = React.createClass
  render: ->
    <div className="manager-edit-subject-page">
      {for x in @props.data.subjects
        <div >
          <input type="checkbox" className="checkbox" data-id={x._id.$oid} /> 
          <label>{x.name}</label>
        </div>     
      }
      <button className="ui primary button" onClick={@save_subjects}>
        保存
      </button>
      <a className="ui button back" href="/manager/courses">
        返回
      </a>
    </div> 

  componentDidMount: ->
    for id in @props.data.self_subjects_ids
      jQuery("[data-id = #{id.$oid}]").attr("checked", "checked")

  save_subjects:()->
    console.log @props.data.course_id
    ids = []
    for item in jQuery(".manager-edit-subject-page .checkbox:checked")
      ids.push(jQuery(item).attr("data-id"))

    jQuery.ajax
      url: "/manager/courses/#{@props.data.course_id}/update_subject"
      type: "POST"
      data: 
        courses_id: @props.data.course_id ,
        subjects_ids: ids
    .success ()=>
        window.location="/manager/courses"
















