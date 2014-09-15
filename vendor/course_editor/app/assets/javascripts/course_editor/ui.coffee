ANIMATE_DURATION = 200
trigger_saved = ->
  jQuery(document).trigger 'tutorial-editor:saved'

class StepDom
  constructor: (@$step)->
    @$container = @$step.closest('.steps')

    @id = @$step.data('id')
    @is_begin = @$step.hasClass('begin')
    @node_num_key = "#{@id}-node-num"

  get_node_num: ->
    return parseInt localStorage[@node_num_key]

  show_content: (node_num)->
    num = @get_node_num()
    if num
      @_show_content(num)
      return false

    @_show_content node_num
    return true


  _show_content: (node_num)->
    localStorage[@node_num_key] = node_num
    if @$step.data('title')
      @$step.find('.text').html @$step.data('title')
    else
      @$step.find('.text').html("页面-#{node_num}")


  set_pos: (left, top)->
    offset = 30
    _left = left + offset
    _top = top + offset

    @$step.data 'left', _left
    @$step.data 'top', _top

    @$step.animate
      left: _left
      top: _top
    , ANIMATE_DURATION, =>
      @$step.fadeIn ANIMATE_DURATION

  data: ->
    return {
      id: @$step.data('id')
      text: @get_text()
      begin: @is_begin
    }

  get_text: ->
    @$step.find('.text').html()

  set_depth: (depth)->
    @$step.data('depth', depth)

  get_depth: ->
    return @$step.data('depth')

  reset_layout: ->
    @$step.data('parents', [])
    @$step.data('ancestors', [])
    @$step.data('positioned', false)

  is_positioned: ->
    return @$step.data('positioned')

  set_positioned: ->
    @$step.data('positioned', true)

  add_parent: (step)->
    parents = @parents()
    parents.push step
    @$step.data('parents', parents)

    # 把父节点祖先加入当前节点祖先
    ancestors = @ancestors()
    ids = ancestors.map (s)-> s.id

    ancestors.push step if ids.indexOf(step.id) is -1
    for as in step.ancestors()
      ancestors.push as if ids.indexOf(as.id) is -1

    @$step.data('ancestors', ancestors)

    # 修改 depth
    d = step.get_depth() + 1
    if d > @get_depth()
      @set_depth d

  parents: ->
    return @$step.data('parents') || []

  ancestors: ->
    return @$step.data('ancestors') || []

  ancestors_include: (step)->
    (@ancestors().map (s)-> s.id).indexOf(step.id) > -1 


  children: ->
    cont = @$step.data('continue-json')

    if cont.type is 'step'
      id = cont.id
      c = @$container.find(".step[data-id=#{id}]")
      return [new StepDom c] if c.length
      return []

    if cont.type is 'select'
      re = []
      for k, data of cont.options
        id = data.id
        if id
          c = @$container.find(".step[data-id=#{id}]")
          re.push new StepDom c
      return re

    return []

  update_continue_json: (cj)->
    @$step.data('continue-json', cj)

class Editor
  constructor: (@$editor, @form)->
    @form.editor = @

    @step_url_prefix = @$editor.data('step-url-prefix')

    @ANI_TIME = 200

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

  init_node_num: ->
    @last_node_num = 0
    for step in @get_step_doms()
      num = step.get_node_num()
      @last_node_num = num if num > @last_node_num
    console.log "loaded node num: #{@last_node_num}" 
    

  bind_events: ->
    # 增加节点
    @$editor.delegate '.top-bar a.create', 'click', (evt)=>
      url = @$editor.data('create-url')
      jQuery.ajax
        url: url
        type: 'POST'
        success: (step_data)=>
          trigger_saved()
          @add_step_response step_data


    # 删除节点
    that = @
    @$editor.delegate '.steps .step:not(.begin) a.delete', 'click', (evt)->
      $elm = jQuery(this)
      step = new StepDom $elm.closest('.step')
      url = that.step_url_prefix + step.id
      parent_ids = step.parents().map (s)-> s.id

      if confirm('确定要删除吗？')
        jQuery.ajax
          url: url
          type: 'DELETE'
          data:
            parent_ids: parent_ids 
          success: (res)->
            trigger_saved()
            that.delete_step_response res

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
    # 获取所有 step 对象
    steps = @get_step_doms()

    # 第一次，线性遍历
    # 起始节点 depth = 1
    # 所有有后续的节点，depth = 1
    # 所有无后续的节点，depth = -1
    for step in steps
      step.reset_layout()
      if step.children().length || step.is_begin
        step.set_depth 1
      else
        step.set_depth -1

    # 第二次，挑选出有后续的节点，深度优先遍历
    # 修正每个节点的 depth 值，并记录其前置节点
    for step in steps
      if step.get_depth() is 1
        @_r2(step)


    # 第三次，找出 depth == 1 的节点，深度优先遍历，挑选出 depth != -1 的节点，摆放位置
    # 深度优先遍历的目的是防止箭头交叉
    @hash = {}
    @max_left = 0
    @max_top = 0
    @deltaW = 124 + 30
    @deltaH = 74 + 30

    for step in steps
      depth = step.get_depth()
      if depth is 1
        @_r3(step, 0)

    # 第四次，线性遍历，摆放 depth == -1 的节点位置
    for step in steps
      if step.get_depth() is -1
        left = 0
        top = @max_top + @deltaH
        @max_top += @deltaH

        step.set_pos left, top
        @_show_content(step)

    # 绘制箭头
    canvasW = @max_left + @deltaW
    canvasH = @max_top + @deltaH
    @layout_arrows(canvasW, canvasH)
    @update_count()

  _r2: (step)->
    for c in step.children()
      c.add_parent step
      @_r2(c)

  _r3: (step, parent_left)->
    return if step.is_positioned()
    step.set_positioned()

    depth = step.get_depth()

    if @hash[depth] is undefined
      @hash[depth] = [step]
    else
      @hash[depth].push step

    left = @deltaW * (@hash[depth].length - 1)
    left = Math.max parent_left, left

    top = @deltaH * (depth - 1)
    @max_top = top if top > @max_top
    @max_left = left if left > @max_left
    
    step.set_pos left, top
    @_show_content(step)

    for c in step.children()
      @_r3 c, left


  layout_arrows: (canvasW, canvasH)->
    steps = @get_step_doms()
    @$step_container.find('canvas').remove()
    $canvas = jQuery('<canvas>')
      .attr 'width', canvasW
      .attr 'height', canvasH
      .appendTo @$step_container
      .hide()
      .delay ANIMATE_DURATION
      .fadeIn()


    @curve_arrow = new CurveArrow $canvas[0]
    # 线性遍历，绘制每个节点和其子节点间的箭头
    # 如果节点的祖先里不包含起始节点，那么标记为不可达节点
    # 包含起始节点，则标记为可达节点
    begin_step = steps[0]
    for step in steps
      if step.id == begin_step.id
        step.$step.removeClass('cannot-reach')
        color = '#000000'
      else if step.ancestors_include(begin_step)
        step.$step.removeClass('cannot-reach')
        color = '#000000'
      else
        step.$step.addClass('cannot-reach')
        color = '#666666'

      for c in step.children()
        # 绘制单箭头
        @curve_arrow.draw_by_dom step.$step, c.$step, color


  _show_content: (step)->
    re = step.show_content(@last_node_num + 1)
    @last_node_num += 1 if re


  add_step_response: (step_data)->
    $template = jQuery('.step-template .step')

    $new_step = $template.clone()
      .attr('data-id', step_data.id)
      .attr('data-continue-json', '{}')
      .attr('data-title', null)
      .appendTo @$step_container
      .hide()
    @layout()

  delete_step_response: (step_data)->
    step = @get_step_dom_by_id step_data.id

    # 移除节点dom
    step.$step
      .addClass 'deleted'
      .hide @ANI_TIME, => 
        step.$step.remove()
    
    # 修改父节点 continue 数据
    for change in step_data.parent_changes
      parent = @get_step_dom_by_id change.id
      parent.update_continue_json change.continue

    @layout()

  # 更新节点计数和不可达节点计数
  update_count: ->
    count = @$editor.find('.step:not(.deleted)').length
    ccount = count - @$editor.find('.step:not(.deleted):not(.cannot-reach)').length

    @$editor.find('.steps-count .count').html count
    @$editor.find('.steps-count .cant-reach-count').html ccount

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

  get_step_dom_by_id: (id)->
    new StepDom @$editor.find(".step[data-id=#{id}]")



class Form
  constructor: (@$form)->
    @$overlay = @$form.closest('.overlay')

    @$title_ipt = @$form.find('.title-ipter input')
    @$title_submit = @$form.find('.title-ipter a.btn')
    @$content_container = @$form.find('.content-container')

    @branch_subform = new BranchForm @$overlay.find('.subform.branch-assigner'), @

    @select_subform = new SelectList @$overlay.find('.subform.select-list'), @
    
    @bind_events()


  bind_events: ->
    @$form.delegate '.header a.close', 'click', =>
      @unload()

    # 修改标题
    that = @
    @$form.delegate '.title-ipter input', 'keypress', (evt)=>
      if evt.keyCode is 13
        evt.preventDefault()
        @do_update_title @$title_ipt.val()


    # 指定后续页面
    _f0 = =>
      @close_subforms()
      steps = @get_optional_steps()
      if @continue_data.type is 'step'
        continue_step_id = @continue_data.id
        steps.map (s)->
          s.selected = true if s.id is continue_step_id
      
      @select_subform.open steps, {
        on_ok: ($item)=>
          @do_update_continue
            continue:
              kind: 'step'
              step_id: $item.data('id')
      }

    that = @
    @$form.delegate '.assigns .another-step', 'click', ->
      _f0()
      that.$form.find('.assigns').addClass('active')
      jQuery(this).addClass('active')

    @$form.delegate '.current-continue .step.text, .current-continue .step.edit', 'click', ->
      _f0()

    # 指定分支
    _f1 = =>
      @close_subforms()
      @branch_subform.open that.continue_data

    that = @
    @$form.delegate '.assigns .branch', 'click', ->
      _f1()
      that.$form.find('.assigns').addClass('active')
      jQuery(this).addClass('active')

    @$form.delegate '.current-continue .select.text, .current-continue .select.edit', 'click', ->
      _f1()


    # 取消已指定的后续
    that = @
    @$form.delegate '.current-continue .cancel', 'click', ->
      that.$form.find('.assigns').addClass('active')
      jQuery(this).addClass('active')
      if confirm('取消当前已经指定的后续吗？')
        that.do_update_continue
          continue: 'end'

    @_text_events()

  _text_events: ->
    # 添加文本内容
    that = @
    @$content_container.delegate '.adds .item.text', 'click', (evt)=>
      @add_text_content ''

    # 编辑内容
    that = @
    @$content_container.delegate '.blocks .block .edit', 'click', (evt)->
      $block = jQuery(this).closest('.block')
      that.edit_block $block

    # textarea 高度自动适应
    that = @
    @$content_container.delegate '.blocks .block textarea', 'keydown', (evt)->
      $textarea = jQuery(this)
      that._wrap_height $textarea

    # 编辑内容取消
    that = @
    @$content_container.delegate '.blocks .block .ops .cancel', 'click', (evt)->
      $block = jQuery(this).closest('.block')
      that.cancel_edit $block

    # 编辑内容确定
    that = @
    @$content_container.delegate '.blocks .block .ops .ok', 'click', (evt)->
      $block = jQuery(this).closest('.block')
      that.do_save_content $block


    # 删除内容
    that = @
    @$content_container.delegate '.blocks .block .delete', 'click', (evt)->
      $block = jQuery(this).closest('.block')
      if confirm '确定要删除这块内容吗？'
        that.do_delete_block $block


  load: ($step)->
    @$overlay.fadeIn ANIMATE_DURATION
    @step_id = $step.data('id')
    @$loaded_step = $step
    @_load_continue($step)
    @_load_content($step)

    @$title_ipt.val($step.data('title'))

  _load_continue: ($step)->
    c = @continue_data = $step.data('continue-json')
    c.type = 'end' if not c.type

    $current_continue = @$form.find('.current-continue')
    $current_continue
      .removeClass('end')
      .removeClass('step')
      .removeClass('select')
      .addClass(c.type)

    switch c.type
      when 'step'
        target_step = @editor.get_step_dom_by_id c.id
        $current_continue.find('.step.text').html target_step.get_text()
        @$form.find('.content-container').addClass('has-continue')
      when 'select'
        @$form.find('.content-container').addClass('has-continue')
      else
        @$form.find('.content-container').removeClass('has-continue')

  _load_content: ($step)->
    @$form.find('.blocks').html('')
    url = @editor.step_url_prefix + @step_id + '/load_content'
    jQuery.ajax
      url: url
      type: 'GET'
      success: (res)=>
        for block_data in res.blocks
         @add_block_dom block_data


  unload: ->
    @close_subforms()
    @$overlay.fadeOut ANIMATE_DURATION
    @$loaded_step.removeClass('selected')


  close_subforms: ->
    @select_subform.close()
    @branch_subform.close()


  # 获取指定后续的候选页面 data 数组
  get_optional_steps: ->
    step = new StepDom @$loaded_step
    aids = step.ancestors().map (s)-> s.id

    @editor.get_steps_data().filter (data)=>
      # 不能指定起始页
      return false if data.begin
      # 不能指定当前页
      return false if data.id is step.id
      # 不能指定所有祖先页
      return false if aids.indexOf(data.id) > -1

      return true

  do_update_title: (title)->
    url = @editor.step_url_prefix + @step_id + '/update_title'
    jQuery.ajax
      url: url
      type: 'PUT'
      data: 
        title: title
      success: (res)=>
        trigger_saved()
        console.log '标题更新成功', res
        @$loaded_step.data('title', res.title)
        new StepDom(@$loaded_step).show_content()


  # 发出请求，更新 continue 数据
  do_update_continue: (continue_data)->
    console.log '更新页面 continue 数据', @step_id, continue_data

    url = @editor.step_url_prefix + @step_id + '/update_continue'

    jQuery.ajax
      url: url
      type: 'PUT'
      data: continue_data
      success: (res)=>
        trigger_saved()
        console.log '页面 continue 数据更新成功', res

        @$loaded_step.data('continue-json', res)
        @_load_continue(@$loaded_step)
        @close_subforms()

        @editor.layout()
    

  add_text_content: (text)->
    url = @editor.step_url_prefix + @step_id + '/add_content'
    jQuery.ajax
      url: url
      type: 'PUT'
      data:
        kind: 'text'
        data: text
      success: (res)=>
        trigger_saved()
        block_data = res.block
        $block = @add_block_dom(block_data)
        @edit_block($block)
        $block
          .hide()
          .fadeIn()

  add_block_dom: (block_data)->
    if block_data.kind is 'text'
      $edit = jQuery('<div><i class="fa fa-pencil"></i></div>')
        .addClass('edit')

      $delete = jQuery('<div><i class="fa fa-times"></i></div>')
        .addClass('delete')

      $pre = jQuery('<pre>')
        .html block_data.content

      $block = jQuery('<div>')
        .attr('data-block-id', block_data.id)
        .attr('data-block-content', block_data.content)
        .addClass('block')
        .addClass('text')
        .append $pre
        .append $edit
        .append $delete
        .appendTo @$content_container.find('.blocks')

      return $block 

  edit_block: ($block)->
    console.log $block.data('block-id')
    $block.addClass('editing')
    $textarea = jQuery('<textarea>')
      .addClass('form-control')
      .val $block.data('block-content')
      .attr 'placeholder', '请输入文字内容'
      .appendTo $block
    $ops = jQuery('<div>')
      .addClass 'ops'
      .appendTo $block
    $ok = jQuery('<a>确定</a>')
      .addClass 'ok btn btn-rounded btn-bdb-fresh btn-mini'
      .appendTo $ops
    $cancel = jQuery('<a>取消</a>')
      .addClass 'cancel btn btn-rounded btn-bdb btn-mini'
      .appendTo $ops

    @_wrap_height $textarea
    setTimeout =>
      @__auto_block_bottom_pos $textarea.closest('.block')
    , 50


  cancel_edit: ($block)->
    val = $block.data('block-content')

    if jQuery.trim(val).length is 0
      @do_delete_block $block
      return

    $block.find('pre').html $block.data('block-content')
    $block.find('textarea').remove()
    $block.find('.ops').remove()
    $block.removeClass('editing')

  do_save_content: ($block)->
    $textarea = $block.find('textarea')
    val = $textarea.val()

    if jQuery.trim(val).length is 0
      @do_delete_block $block
      return

    $block.data('block-content', val)

    url = @editor.step_url_prefix + @step_id + '/update_content'

    jQuery.ajax
      url: url
      type: 'PUT'
      data:
        block_id: $block.data('block-id')
        content: $block.data('block-content')
      success: (res)=>
        trigger_saved()
        @cancel_edit $block


  do_delete_block: ($block)->
    url = @editor.step_url_prefix + @step_id + '/delete_content'
    jQuery.ajax
      url: url
      type: 'DELETE'
      data:
        block_id: $block.data('block-id')
      success: (res)=>
        $block.fadeOut -> 
          $block.remove()
        ANIMATE_DURATION
        trigger_saved()

  _wrap_height: ($textarea)->
    $pre = $textarea.closest('.block').find('pre')

    setTimeout =>
      val = $textarea.val()
      $pre.html(val + ' ')
      setTimeout =>
        height = $pre.height()
        $textarea.css 'height', height + 12 + 20

        setTimeout =>
          caret_top = $textarea.textareaHelper('caretPos').top
          $block = $textarea.closest('.block')
          block_height = $block.outerHeight()

          if block_height - caret_top < 110 || @_auto
            @auto = false
            @__auto_block_bottom_pos $block
        , 0
      , 0
    , 0

  __auto_block_bottom_pos: ($block)->
    # console.log 'auto pos'
    $scroller = $block.closest('.scroller')
    scr_height   = $scroller.height()
    scr_s_height = $scroller[0].scrollHeight
    sct_s_top    = $scroller.scrollTop()
    
    block_height = $block.outerHeight()
    block_top    = $block.position().top

    realtop    = sct_s_top + block_top
    realbottom = realtop + block_height

    scr_s_bottom = sct_s_top + scr_height

    # console.log scr_s_bottom, realbottom

    if scr_s_bottom < realbottom
      $scroller.scrollTop sct_s_top + realbottom - scr_s_bottom


class SubForm
  close: ->
    @mainform.$overlay.find('.subform').hide(ANIMATE_DURATION)
    @mainform.$form
      .find('.assigns').removeClass('active').end()
      .find('.assigns .item').removeClass('active').end()


class BranchForm extends SubForm
  constructor: (@$elm, @mainform)->
    @$options = @$elm.find('.options')
    @$add_option = @$elm.find('.add-option')
    @$question_ipter = @$elm.find('.question textarea')

    @$btn_ok = @$elm.find('.btn.ok')
    @$btn_cancel = @$elm.find('.btn.cancel')
    @bind_events()

  bind_events: ->
    # 确定按钮被按下
    @$btn_ok.on 'click', => @on_ok()

    # 取消按钮被按下
    @$btn_cancel.on 'click', => @close()

    # 增加选项
    @$add_option.on 'click', => @add_option().hide().slideDown()

    # 移除选项
    that = @
    @$elm.delegate '.options .option .delete', 'click', ->
      $option = jQuery(this).closest('.option')
        .addClass('delete')
        .slideUp ->
          $option.remove()
      that.refresh_count()

    # 指定对应页面
    that = @
    @$elm.delegate '.options .option .assign-q-step', 'click', ->
      $option = jQuery(this).closest('.option')
      option_id = $option.data('step-id')
      mainform = that.mainform
      steps = mainform.get_optional_steps()
      # 再过滤一次
      steps = steps.filter (data)=>
        if data.id is option_id
          data.selected = true
          return true
        return false if that.get_option_step_ids().indexOf(data.id) > -1
        return true

      that.mainform.select_subform.open steps, {
        on_open: ->
          that.disable()
          mainform.select_subform.$elm.addClass 'option-assigner'
        on_close: ->
          that.enable()
          mainform.select_subform.$elm.removeClass 'option-assigner'
        on_ok: ($item)=>
          data = {
            id: $item.data('id')
            text: $item.data('text')
          }
          that.set_option $option, data
          mainform.select_subform.close()
      }


    @$elm.delegate 'textarea', 'keydown', =>
      setTimeout =>
        @check_data()
      , 0


  open: (continue_data)->
    @enable()
    @$elm.show(ANIMATE_DURATION)
    @$options.html('')

    if continue_data.type is 'select'
      @$question_ipter.val continue_data.question
      for key, option of continue_data.options
        $option = @add_option()
        $option.find('textarea').val option.text

        if option.id and option.id is not ''
          step = @mainform.editor.get_step_dom_by_id option.id
          @set_option $option, step.data()

    else
      @$question_ipter.val ''
      for i in [0...2]
        @add_option()

    @check_data()

  add_option: ->
    $option = @$elm.find('.template .option').clone()
    $option.appendTo @$options
    @refresh_count()
    $option

  refresh_count: ->
    if @$elm.find('.options .option:not(.delete)').length > 2
      @$elm.find('.options .option .delete').show()
    else
      @$elm.find('.options .option .delete').hide()
    @check_data()

  get_data: ->
    question = @$question_ipter.val()
    options = []
    @$elm.find('.options .option:not(.delete)').each ->
      $option = jQuery(this)
      options.push
        text: $option.find('textarea').val()
        id: $option.data('step-id')

    return {
      question: question
      options: options
    }

  check_data: ->
    flag = true
    if not @$question_ipter.val().length
      flag = false
      @$question_ipter.addClass 'error'
    else
      @$question_ipter.removeClass 'error'

    @$elm.find('.options .option:not(.delete)').each ->
      $option = jQuery(this)
      $textarea = $option.find('textarea')
      if not $textarea.val().length
        flag = false
        $textarea.addClass 'error'
      else
        $textarea.removeClass 'error'

    if flag
      @$btn_ok.removeClass('disabled')
    else
      @$btn_ok.addClass('disabled')


  on_ok: ->
    return if @$btn_ok.hasClass('disabled')
    data = @get_data()
    @mainform.do_update_continue
      continue:
        kind: 'select'
        question: data.question
        options: data.options

  disable: ->
    @$elm.addClass('disabled')

  enable: ->
    @$elm.removeClass('disabled')

  set_option: ($option, step_data)->
    $option.data('step-id', step_data.id)
    $option.find('.current').html step_data.text

  get_option_step_ids: ->
    re = []
    @$elm.find('.options .option:not(.delete)').each ->
      $option = jQuery(this)
      re.push $option.data('step-id') if $option.data('step-id')
    re


jQuery(document).on 'ready page:load', ->
  if jQuery('.page-course-editor-tutorials-edit .editor').length
    form = new Form jQuery('.page-course-editor-tutorials-edit .step-form')
    editor = new Editor jQuery('.page-course-editor-tutorials-edit .editor'), form

jQuery(document).on 'tutorial-editor:saved', ->
  $saved = jQuery('.page-header .saved')
    .stop()
    .hide()
    .fadeIn(50)
    .delay(2000)
    .fadeOut 1000, -> $saved.hide()