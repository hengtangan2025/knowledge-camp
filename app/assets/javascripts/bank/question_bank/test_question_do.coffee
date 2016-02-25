class Questiondo
  constructor: (@$ele, options)->
    @bind_event()
    @type = options["type"]

  bind_event: ->
    @bind_form_submit_event()

  bind_form_submit_event: ->
    @$ele.on 'submit', '.question form', (evt)=>
      evt.preventDefault()
      target = jQuery evt.target

      jQuery.ajax
        url: target.attr("action")
        method: "post"
        data: target.serializeArray()
        success: (msg)=>
          @submit_callback(target, msg)


  submit_callback: (target, msg)->
    if @type == "redo"
      @submit_redo_callback(target, msg)
    if @type == "random"
      @submit_random_callback(target, msg)

  submit_redo_callback: (target, msg)->
    if msg.is_correct
      target.find(".question-result-info").html "<div class='text-success'>回答正确</div>"
    else
      target.find(".question-result-info").html "<div class='text-danger'>回答错误</div>"

  submit_random_callback: (target, msg)->
    if msg.is_correct
      target.find(".question-result-info").html "<div class='text-success'>回答正确，正在载入下一题</div>"
    else
      target.find(".question-result-info").html "<div class='text-danger'>回答错误，正在载入下一题</div>"

    setTimeout =>
      window.location.href = window.location.href
    , 500


jQuery(document).on "ready page:load", ->
  if jQuery(".page-question-do-form").length > 0
    new Questiondo jQuery(".page-question-do-form"),
      type: "redo"

  if jQuery(".page-question-random").length > 0
    new Questiondo jQuery(".page-question-random"),
      type: "random"
