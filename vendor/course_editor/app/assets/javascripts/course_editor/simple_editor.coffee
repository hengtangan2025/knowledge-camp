STEP_DOM_HEIGHT = 134
ANIMATE_DURATION = 200
trigger_saved = ->
  jQuery(document).trigger 'tutorial-editor:saved'

class StepDom
  constructor: (@$elm)->
    @id = @$elm.data('id')
    @node_num_key = "#{@id}-node-num-simple"

  change_content: (node_num)->
    num = @get_node_num()
    if num
      @_change_content(num)
      return false
    @_change_content node_num
    return true


  _change_content: (node_num)->
    localStorage[@node_num_key] = node_num
    if @$elm.data('title')
      @$elm.find('.text').html @$elm.data('title')
    else
      @$elm.find('.text').html("页面 - #{node_num}")


  get_node_num: ->
    return parseInt localStorage[@node_num_key]

  prev: ->
    $prev_elm = @$elm.prevAll('.step:not(.deleted)').first()
    return new StepDom $prev_elm if $prev_elm.length
    null

  next: ->
    $next_elm = @$elm.nextAll('.step:not(.deleted)').first()
    return new StepDom $next_elm if $next_elm.length
    null

  remove: ->
    @$elm
      .addClass 'deleted'
      .hide ANIMATE_DURATION, => 
        @$elm.remove()

  up: ->
    prev = @prev()
    if prev
      prev.$elm.before @$elm
      prev.$elm.css 'top', -STEP_DOM_HEIGHT
      @$elm.css 'top', STEP_DOM_HEIGHT

      prev.$elm.animate
        'top': '0'
      , ANIMATE_DURATION

      @$elm.animate
        'top': '0'
      , ANIMATE_DURATION

  down: ->
    next = @next()
    if next
      next.$elm.after @$elm
      next.$elm.css 'top', STEP_DOM_HEIGHT
      @$elm.css 'top', -STEP_DOM_HEIGHT

      next.$elm.animate
        'top': '0'
      , ANIMATE_DURATION

      @$elm.animate
        'top': '0'
      , ANIMATE_DURATION   
        

  addClass: (klass)->
    @$elm.addClass klass
    @

  removeClass: (klass)->
    @$elm.removeClass klass
    @

  set_num: (num)->
    @$elm.find('.num').html num


class Editor
  constructor: (@$editor, @form)->
    @form.editor = @
    @step_url_prefix = @$editor.data 'step-url-prefix'
    @$step_container = @$editor.find('.steps')
    
    @init_node_num()

    @bind_events()
    @layout()

  # 获取节点对象数组
  get_step_doms: ->
    re = []
    @$editor.find('.step:not(.deleted)').each ->
      re.push new StepDom jQuery(this)
    re


  each_step_do: (func)->
    steps = @get_step_doms()
    for i in [0...steps.length]
      step = steps[i]
      func(i, step)
    steps


  get_step_dom_by_id: (id)->
    new StepDom @$editor.find(".step[data-id=#{id}]")


  init_node_num: ->
    @last_node_num = 0
    for step in @get_step_doms()
      num = step.get_node_num()
      @last_node_num = num if num > @last_node_num
    console.log "loaded node num: #{@last_node_num}" 


  bind_events: ->
    # hover
    @$editor.delegate '.steps .step .hoverdiv', 'mouseenter', (evt)->
      jQuery(this).closest('.step').addClass('hovered')

    @$editor.delegate '.steps .step .hoverdiv', 'mouseleave', (evt)->
      jQuery(this).closest('.step').removeClass('hovered')

    # select
    that = @
    @$editor.delegate '.steps .step .hoverdiv', 'click', (evt)->
      that.select jQuery(this).closest('.step')

    # 删除节点
    that = @
    @$editor.delegate '.steps .op.delete', 'click', (evt)->
      $elm = jQuery(this)
      step = new StepDom $elm.closest('.step')
      url = that.step_url_prefix + step.id + '/simple_delete'

      prev_id = (step.prev() || {}).id
      next_id = (step.next() || {}).id

      if confirm('确定要删除吗？')
        console.log "prev: " + prev_id
        console.log "next: " + next_id
        jQuery.ajax
          url: url
          type: 'DELETE'
          data:
            prev_id: prev_id
            next_id: next_id
          success: (res)->
            console.log res
            trigger_saved()
            that.delete_step_response res

    # 增加节点
    that = @
    @$editor.delegate '.steps .op.add', 'click', (evt)->
      $elm = jQuery(this)
      step = new StepDom $elm.closest('.step')
      url = that.step_url_prefix + step.id + '/simple_add'

      step_id = step.id
      next_id = (step.next() || {}).id

      jQuery.ajax
        url: url
        type: 'POST'
        data:
          step_id: step_id
          next_id: next_id
        success: (res)->
          trigger_saved()
          that.add_step_response res

    # 上移
    that = @
    @$editor.delegate '.steps .op.up', 'click', (evt)->
      $elm = jQuery(this)
      step = new StepDom $elm.closest('.step')
      url = that.step_url_prefix + step.id + '/simple_up'

      prev_prev_id = (step.prev().prev() || {}).id
      prev_id = (step.prev() || {}).id
      next_id = (step.next() || {}).id

      # console.log step.prev().$elm.find('.text').html()

      jQuery.ajax
        url: url
        type: 'PUT'
        data:
          prev_prev_id: prev_prev_id
          prev_id: prev_id
          next_id: next_id
        success: (res)->
          trigger_saved()
          that.up_step_response res

    # 下移
    that = @
    @$editor.delegate '.steps .op.down', 'click', (evt)->
      $elm = jQuery(this)
      step = new StepDom $elm.closest('.step')
      url = that.step_url_prefix + step.id + '/simple_down'

      next_next_id = (step.next().next() || {}).id
      next_id = (step.next() || {}).id
      prev_id = (step.prev() || {}).id

      jQuery.ajax
        url: url
        type: 'PUT'
        data:
          next_next_id: next_next_id
          next_id: next_id
          prev_id: prev_id
        success: (res)->
          trigger_saved()
          that.down_step_response res


  select: ($step)->
    @$editor.find('.step:not(.deleted)').removeClass('selected')
    $step.addClass('selected')
    @form.load new StepDom $step

  delete_step_response: (res)->
    step = @get_step_dom_by_id res.id
    step.remove()
    @layout()

  add_step_response: (res)->
    prev_step = @get_step_dom_by_id res.step_id
    $new_step = @$editor.find('.step').first().clone()
      .attr('data-id', res.id)
    
    prev_step.$elm.after $new_step
    $new_step.hide().show ANIMATE_DURATION
    @layout()

  up_step_response: (res)->
    step = @get_step_dom_by_id res.id
    step.up()
    @layout()

  down_step_response: (res)->
    step = @get_step_dom_by_id res.id
    step.down()
    @layout()


  layout: ->
    steps = @each_step_do (i, step)=>
      step.removeClass('begin').removeClass('end')
      step.addClass('begin') if not step.prev()
      step.addClass('end') if not step.next() 
      step.set_num i + 1

      # change contnet
      @last_node_num += 1 if step.change_content(@last_node_num + 1)

    canvasW = 254
    canvasH = 30 + steps.length * STEP_DOM_HEIGHT
    @layout_arrows canvasW, canvasH

  layout_arrows: (canvasW, canvasH)->
    @$step_container.find('canvas').remove()
    $canvas = jQuery('<canvas>')
      .attr 'width', canvasW
      .attr 'height', canvasH
      .appendTo @$step_container
      .hide()
      .delay ANIMATE_DURATION
      .fadeIn()

    @curve_arrow = new CurveArrow $canvas[0]
    @each_step_do (i, step)=>
      x0 = 30 + 214 / 2
      x1 = x0
      y0 = (i + 1) * STEP_DOM_HEIGHT
      y1 = y0 + 30

      return if not step.next()
      @curve_arrow.draw x0, y0, x1, y1, '#666666'


class CEForm
  constructor: (@$form)->
    @$blocks = @$form.find('.blocks')

    @bind_events()

  load: (step)->
    @current_step = step
    url = url = @editor.step_url_prefix + step.id + '/simple_load_content_html'

    @$blocks.html('')
    jQuery.ajax
      url: url
      type: 'GET'
      success: (res)=>
        @$blocks.html(res.html)

  bind_events: ->
    # 添加文本内容
    that = @
    @$form.delegate 'a.add.text', 'click', (evt)=>
      @add_text_content ''

  add_text_content: (text)->
    url = @editor.step_url_prefix + @current_step.id + '/add_content'
    jQuery.ajax
      url: url
      type: 'PUT'
      data:
        kind: 'text'
        data: text
      success: (res)=>
        trigger_saved()
        $block = jQuery res.html
        @$blocks.append $block
        @edit_block $block


jQuery(document).on 'ready page:load', ->
  if jQuery('.page-course-editor-tutorials-simple_design .simple-editor').length
    console.log "挖掘机技术哪家强？"
    
    form = new CEForm jQuery('.page-course-editor-tutorials-simple_design .content-editor')
    editor = new Editor jQuery('.page-course-editor-tutorials-simple_design .simple-editor'), form
