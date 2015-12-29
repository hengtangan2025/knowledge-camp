question_bank_engine_prefix = "/bank/question_bank"

class QuestionRecordList
  constructor: (@$ele)->
    @bind_event()

  bind_event: ()->
    @bind_check_all_event()

    @bind_delete_event()
    @bind_into_flaw_event()

    @bind_batch_into_flaw_event()
    @bind_batch_delete_event()

  bind_check_all_event: ->
    @$ele.on "click", ".record-batch input[type='checkbox'][name='check-all']", (evt)=>
      target = jQuery evt.target
      @$ele.find("table tbody input[type='checkbox'][name='record']").prop("checked", target.is(':checked'))

  bind_delete_event: ->
    @$ele.on "click", "table tbody td .delete-record", (evt)=>
      return if !confirm("确定删除么？")

      target = jQuery evt.target
      tr = target.closest "tr"
      question_record_id = target.data "questionRecordId"
      jQuery.ajax
        url: "#{question_bank_engine_prefix}/question_records/#{question_record_id}"
        method: "DELETE"
        dataType: "json"
        success: (msg)=>
          tr.remove()

  bind_into_flaw_event: ->
    @$ele.on "click", "table tbody td .into-flaw", (evt)=>
      return if !confirm("确定么？")

      target = jQuery evt.target
      $tr = target.closest("tr")

      question_id = target.data "questionId"
      jQuery.ajax
        url: "#{question_bank_engine_prefix}/question_flaws"
        method: "post"
        data:
          question_id: question_id
        dataType: "json"
        success: (msg)=>
          @_change_tr_to_intoed_flaw($tr)

  bind_batch_into_flaw_event: ->
    @$ele.on "click", ".record-batch .batch-into-flaw", (evt)=>
      eles = @$ele.find("table tbody input:checked[type='checkbox'][name='record']").get()

      $tr_arr = jQuery.map eles, (ele)->
        jQuery(ele).closest("tr")

      $tr_arr = jQuery.grep $tr_arr, ($tr)->
        $tr.find("td a.into-flaw").length != 0

      ids = jQuery.map $tr_arr, ($tr)->
        return $tr.find(".into-flaw").data("questionId")

      return if ids.length == 0
      return if !confirm("确定么？")

      jQuery.ajax
        url: "#{question_bank_engine_prefix}/question_flaws/batch_create"
        method: "post"
        data:
          question_ids: ids
        dataType: "json"
        success: (msg)=>
          jQuery.each $tr_arr, (index, $tr)=>
            @_change_tr_to_intoed_flaw($tr)

  bind_batch_delete_event: ->
    @$ele.on "click", ".record-batch .batch-delete-record", (evt)=>
      eles = @$ele.find("table tbody input:checked[type='checkbox'][name='record']").get()

      $tr_arr = jQuery.map eles, (ele)->
        jQuery(ele).closest("tr")

      ids = jQuery.map eles, (ele)->
        return jQuery(ele).closest("tr").find(".delete-record").data("questionRecordId")

      return if ids.length == 0
      return if !confirm("确定么？")

      jQuery.ajax
        url: "#{question_bank_engine_prefix}/question_records/batch_destroy"
        method: "delete"
        data:
          question_record_ids: ids
        dataType: "json"
        success: (msg)=>
          jQuery.each $tr_arr, (index, $tr)=>
            $tr.remove()


  _change_tr_to_intoed_flaw: ($tr)->
    into_flaw = $tr.find("td a.into-flaw")
    return if into_flaw.length == 0
    into_flaw.remove()
    $tr.find("td span.flawed").removeClass("hide")


jQuery(document).on "ready page:load", ->
  if jQuery(".page-question-records").length > 0
    new QuestionRecordList(jQuery(".page-question-records"))
