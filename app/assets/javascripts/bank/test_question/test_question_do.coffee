question_bank_engine_prefix = "/bank/question_bank"

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
      console.log target.serializeArray()

      jQuery.ajax
        url: target.attr("action")
        method: "post"
        data: target.serializeArray()
        success: (msg)=>
          console.log msg

jQuery(document).on "ready page:load", ->
  if jQuery(".page-question-do-form").length > 0
    new QuestionRedo jQuery(".page-question-do-form"),
      type: "redo"

  if jQuery(".page-question-random").length > 0
    new QuestionRedo jQuery(".page-question-random"),
      type: "random"
