ANIMATE_DURATION = 200

class StepDom
  constructor: (@$step)->

  set_node_num: (num)->
    if @$step.data('node-num')
      return false

    @$step.data('node-num', num)
    @$step.find('.text').html("页面-#{num}")
    return true

  set_pos: (left, top)->
    offset = 30
    @$step.animate
      left: left + offset
      top: top + offset
    , ANIMATE_DURATION, =>
      @$step.fadeIn ANIMATE_DURATION

  data: ->
    return {
      id: @$step.data('id')
      text: @$step.find('.text').html()
      begin: @$step.hasClass('begin')
    }

class Editor
  constructor: (@$editor, @form)->
    @form.editor = @

    @step_url_prefix = @$editor.data('step-url-prefix')

    @ANI_TIME = 200

    @$step_container = @$editor.find('.steps')

    @init_title_num()

    @bind_events()
    @layout()

  init_title_num: ->
    @title_num = 1
    that = @
    @$editor.find('.step:not(.deleted)').each ->
      num = jQuery(this).data('title-num')
      that.title_num = num if num > that.title_num
      console.log "init title num: #{that.title_num}" 


  bind_events: ->
    # ------------ create button
    @$create_button = @$editor.find('.top-bar a.create')
    @$create_button.on 'click', =>
      url = @$editor.data('create-url')
      jQuery.ajax
        url: url
        type: 'POST'
        success: (step_data)=>
          console.log step_data
          @add_step_response step_data

    # step delete
    that = @
    @$editor.delegate '.steps .step:not(.first) a.delete', 'click', (evt)->
      $elm = jQuery(this)
      $step = $elm.closest('.step')
      id = $step.data('id')
      url = that.step_url_prefix + id
      if confirm('确定要删除吗？')
        jQuery.ajax
          url: url
          type: 'DELETE'
          success: (data)=>
            console.log data
            that.delete_step_response data

    # hover
    @$editor.delegate '.steps .step .hoverdiv', 'mouseenter', (evt)->
      $elm = jQuery(this)
      $step = $elm.closest('.step')
      $step.addClass('hovered')

    @$editor.delegate '.steps .step .hoverdiv', 'mouseleave', (evt)->
      $elm = jQuery(this)
      $step = $elm.closest('.step')
      $step.removeClass('hovered')

    # select
    that = @
    @$editor.delegate '.steps .step .hoverdiv', 'click', (evt)->
      $elm = jQuery(this)
      $step = $elm.closest('.step')
      that.select($step)


  layout: ->
    $steps = @$editor.find('.step:not(.deleted)')
    arr = (step for step in $steps)

    crt_left = 0
    crt_top = 0

    while arr.length > 0
      $step = jQuery(arr.shift())
      new StepDom($step).set_pos(crt_left, crt_top)
      crt_top += $step.height() + 30

      @_show_content($step)

  _show_content: ($step)->
    if new StepDom($step).set_node_num @title_num
      @title_num += 1

  add_step_response: (step_data)->
    @_update_count step_data.total_count

    $last = @$editor
      .find('.step').last()

    $new_step = $last.clone()
      .removeClass('first')
      .attr('data-id', step_data.id)
      .appendTo @$step_container
    @layout()

  delete_step_response: (step_data)->
    @_update_count step_data.total_count

    $step = @$editor.find(".step[data-id=#{step_data.id}]")
    $step
      .addClass 'deleted'
      .hide @ANI_TIME, => 
        $step.remove()
    @layout()

  _update_count: (count)->
    @$editor.find('.steps-count .count').html count

  select: ($step)->
    @$editor.find('.step:not(.deleted)').removeClass('selected')
    $step.addClass('selected')
    @form.load $step

  get_steps_data: ->
    re = []
    @$editor.find('.step:not(.deleted)').each ->
      $step = jQuery(this)
      re.push new StepDom($step).data()
    re

class Form
  constructor: (@$form)->
    @$overlay = @$form.closest('.overlay')
    @bind_events()

  bind_events: ->
    @$form.delegate '.header a.close', 'click', =>
      @unload()

    @bind_assign_step_events()

    # ---------------
    that = @
    @$overlay.delegate '.subform .btns .cancel', 'click', ->
      that._close_assigns()

  bind_assign_step_events: ->
    # 指定后续页面
    that = @
    @$form.delegate '.assigns .another-step', 'click', ->
      that.$form.find('.assigns').addClass('active')
      jQuery(this).addClass('active')

      that.open_another_step_assigner()

    # 指定后续页面的表单选项
    that = @
    @$overlay.delegate '.subform.continue-page-assigner .list .step', 'click', ->
      $step = jQuery(this)
      console.log $step.data('data')
      $step.closest('.list').find('.step').removeClass('selected')
      $step.addClass('selected')

      jQuery('.subform.continue-page-assigner .btns .btn.ok').removeClass('disabled')


    # 指定后续页面表单的确定
    that = @
    @$overlay.delegate '.subform.continue-page-assigner .btns .btn.ok:not(.disabled)', 'click', ->
      data = jQuery('.subform.continue-page-assigner .step.selected').data('data')
      url = that.editor.step_url_prefix + that.step_id + '/update_continue'

      jQuery.ajax
        url: url
        type: 'PUT'
        data:
          continue:
            kind: 'step'
            step_id: data.id
        success: (res)->
          console.log res


  load: ($step)->
    @$overlay.fadeIn()
    @step_id = $step.data('id')
    @$loaded_step = $step

  unload: ->
    @_close_assigns()
    @$overlay.fadeOut()
    @$loaded_step.removeClass('selected')

  _close_assigns: ->
    @$overlay.find('.subform').hide(ANIMATE_DURATION)
    @$form.find('.assigns').removeClass('active')
    @$form.find('.assigns .item').removeClass('active')

  open_another_step_assigner: ->
    $assigner = @$overlay.find '.subform.continue-page-assigner'
    $assigner
      .find('.list').html('').end()
      .show(ANIMATE_DURATION)

    steps_data = @editor.get_steps_data()

    count = 0
    for data in steps_data
      # 不能指定起始页
      continue if data.begin
      # 不能指定当前页
      continue if data.id is @step_id

      $step = $assigner.find('.template .step').clone()
      $step
        .data('data', data)
        .find('.text').html(data.text).end()
        .appendTo $assigner.find('.list')
      count += 1

    $assigner.find('.btn.ok').addClass('disabled')
    
    if count is 0
      jQuery('<div>')
        .addClass('blank')
        .html('没有可指定的页面')
        .appendTo $assigner.find('.list')
      return

jQuery(document).on 'ready page:load', ->
  if jQuery('.page-course-editor-tutorials-edit .editor').length
    form = new Form jQuery('.page-course-editor-tutorials-edit .step-form')
    editor = new Editor jQuery('.page-course-editor-tutorials-edit .editor'), form