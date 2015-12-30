question_bank_engine_prefix = "/bank/question_bank"

class TestPaperResult
  constructor: (@$ele)->
    @bind_event()

  bind_event: ->
    @bind_form_submit_event()

  bind_form_submit_event: ->
    @$ele.on 'submit', 'form', (evt)=>
      evt.preventDefault()
      target = jQuery evt.target
      console.log target.serializeArray()
      # jQuery.ajax
      #   url: target.attr("action")
      #   method: "post"
      #   data: target.serializeArray()
      #   success: (msg)=>
      #     @submit_callback(target, msg)

  submit_callback: (target, msg)->
    console.log msg
    # @$ele.find("ul.section-questions li[data-question-id='566fd8946465622615080000'] .result").html "
    #   哈哈
    # "

jQuery(document).on "ready page:load", ->
  if jQuery(".page-test-paper-result-new").length > 0
    new TestPaperResult jQuery(".page-test-paper-result-new")
