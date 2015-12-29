class @NumConv
  @cn_arr: ["零","一","二","三","四","五","六","七","八","九","十"]
  @cn_desc_arr: ["","十","百","千"]

  @index_2_upcase_letter: (index)->
    String.fromCharCode(65 + index)

  @index_2_cn: (index)->
    str = "#{index+1}"
    index_arr = str.split("")
    index_arr_reverse = []
    res_arr = []
    for i in index_arr
      index_arr_reverse.unshift(i)
    for i,idx in index_arr_reverse
      if i == '0' && res_arr[0] != "零"
        res_arr.unshift "#{@cn_arr[i]}"
      if i != '0'
        res_arr.unshift "#{@cn_arr[i]}#{@cn_desc_arr[idx]}"

    res_arr[0] = "十" if res_arr[0] == "一十"
    res_arr[res_arr.length-1] = "" if res_arr[res_arr.length-1] == "零"
    res_arr.join ""


@TestPaperFiller = React.createClass
  displayName: "TestPaperFiller"
  render: ->
    <div className='test-paper-filler'>
      <TestPaperFiller.Header test_paper={@props.test_paper}/>
      <TestPaperFiller.SectionsList test_paper={@props.test_paper} />
      <div>
        <a className='btn btn-default btn-large' onClick={@do_submit}>交卷</a>
      </div>
    </div>

  do_submit: ->
    questions = []

    for section in @props.test_paper.sections
      for question in section.questions
        questions.push question

    message = if (questions.filter (x)-> x.answered).length == questions.length
      "答完了，确定要提交吗？"
    else
      "你还有没回答的题，确定要提交吗？"

    if confirm message
      data =
        test_paper_result:
          question_records_attributes: questions.map (x)=>
            user_id: @props.current_user_id
            question_id: x.id
            answer: x.answer || ""

      jQuery.ajax
        url: @props.submit_url
        method: "post"
        data: data
        success: (msg)=>
          for question in questions
            question.is_correct = msg[question.id].is_correct
            question.correct_answer = msg[question.id].correct_answer
            question.submitted  = true
            question.react_dom.setState {is_correct: question.is_correct, submitted: true}


  statics:
    Header: React.createClass
      displayName: 'Header'
      render: ->
        <div className='header'>
          <h1 className='text-center'>{@props.test_paper.title}</h1>
          <div className='text-center'>
            <span>试卷满分 {@props.test_paper.score} 分</span>
            <span>考试时间 {@props.test_paper.minutes} 分钟</span>
          </div>
        </div>

    # 这层好像没啥必要，干掉吧
    SectionsList: React.createClass
      displayName: 'SectionsList'
      getInitialState: ->
        sections: @props.test_paper.sections

      render: ->
        <div className='section-list'>
        {
          for section,idx in @state.sections
            <TestPaperFiller.Section key={section.id} section={section} idx={idx}/>
        }
        </div>

    Section: React.createClass
      displayName: 'Section'
      getInitialState: ->
        questions: @props.section.questions
      render: ->
        section = @props.section

        <div className='section'>
          <h3>
            <span>{NumConv.index_2_cn @props.idx}、</span>
            <span>{section.kind_text}</span>
            <span>(共{section.questions.length}题，每题{section.score}分)</span>
          </h3>

        {
          for question,idx in @state.questions
            <TestPaperFiller.Question key={question.id} question={question} idx={idx} />
        }
        </div>

    Question: React.createClass
      displayName: 'Question'
      statics:
        get_correct_answer: (question)->
          if question.kind is 'single_choice' || question.kind is 'multi_choice'
            correct_index = []
            for opt, idx in question.correct_answer
              correct_index.push idx if opt[1]
            upcase_letter_arr = correct_index.map (index)=> NumConv.index_2_upcase_letter(index)
            return upcase_letter_arr.join(",")

          if question.kind is 'bool'
            if question.correct_answer
              return "正确"
            else
              return "错误"

          if question.kind is 'fill'
            return question.correct_answer.join("，")

          if question.kind is 'essay'
            return question.correct_answer

          if question.kind is 'mapping'
            return question.correct_answer.map (ca)->
              "#{ca[0]} -> #{ca[1]}"
            .join "，"

      getInitialState: ->
        answered: false
        is_correct: false
        submitted: false
      render: ->
        question = @props.question
        question.react_dom = @

        class_name = "question"
        if @state.submitted && !@state.is_correct
          class_name = "#{class_name} answer_is_wrong"
        if !@state.submitted && @state.answered
          class_name = "#{class_name} answered"

        <div className={class_name} >
          <div>{@props.idx+1}、{question.content}</div>
          {
            if @state.submitted && @state.is_correct
              <div className='result text-success'>回答正确</div>

            else if @state.submitted && !@state.is_correct
              <div className='result text-danger'>
                <div>回答错误</div>
                <div>正确答案:{TestPaperFiller.Question.get_correct_answer(@props.question)}</div>
              </div>
          }

          {
            if question.kind is 'single_choice'
              <TestPaperFiller.QuestionSingleChoiceInputer question={question} parent={@} />

            else if question.kind is 'multi_choice'
              <TestPaperFiller.QuestionMultiChoiceInputer question={question} parent={@} />

            else if question.kind is 'bool'
              <TestPaperFiller.QuestionBoolInputer question={question} parent={@} />

            else if question.kind is 'fill'
              <TestPaperFiller.QuestionFillInputer question={question} parent={@} />

            else if question.kind is 'essay'
              <TestPaperFiller.QuestionEssayInputer question={question} parent={@} />

            else if question.kind is 'mapping'
              <TestPaperFiller.QuestionMappingInputer question={question} parent={@} />
          }
        </div>

    QuestionSingleChoiceInputer: React.createClass
      displayName: 'QuestionSingleChoiceInputer'
      render: ->
        <div className='choices'>
        {
          for choice, idx in @props.question.choices
            <div key={idx} className='radio'>
              <label>
                <input name="question-#{@props.question.id}" type='radio' onChange={@do_change} value={idx} />
                <span>{NumConv.index_2_upcase_letter idx}、{choice}</span>
              </label>
            </div>
        }
        </div>

      do_change: (evt)->
        @props.question.answer = evt.target.value

        if @props.question.answer? and @props.question.answer != ''
          @props.parent.setState answered: true
          @props.question.answered = true
        else
          @props.parent.setState answered: false
          @props.question.answered = false

    QuestionMultiChoiceInputer: React.createClass
      displayName: 'QuestionMultiChoiceInputer'
      render: ->
        <div className='choices'>
        {
          for choice, idx in @props.question.choices
            <div key={idx} className='checkbox'>
              <label>
                <input type='checkbox' onChange={@do_change} value={idx} />
                <span>{NumConv.index_2_upcase_letter idx}、{choice}</span>
              </label>
            </div>
        }
        </div>

      do_change: (evt)->
        $selected_checkboxes = jQuery(React.findDOMNode @).find('input[type=checkbox]:checked')
        if $selected_checkboxes.length == 0
          @props.question.answer = undefined
        else
          values = {}
          for choice, idx in @props.question.choices
            values[String(idx)] = false
          for x in $selected_checkboxes
            values[String(jQuery(x).val())] = true
          @props.question.answer = values

        if @props.question.answer?
          @props.parent.setState answered: true
          @props.question.answered = true
        else
          @props.parent.setState answered: false
          @props.question.answered = false

    QuestionBoolInputer: React.createClass
      displayName: 'QuestionBoolInputer'
      render: ->
        <div className='choices'>
          <div className='radio'>
            <label>
              <input type='radio' name={"bool_#{@props.question.id}"} onChange={@do_change} value='true'/>
              <span>正确</span>
            </label>
          </div>
          <div className='radio'>
            <label>
              <input type='radio' name={"bool_#{@props.question.id}"} onChange={@do_change} value='false'/>
              <span>错误</span>
            </label>
          </div>
        </div>

      do_change: (evt)->
        @props.question.answer = evt.target.value

        if @props.question.answer? and @props.question.answer != ''
          @props.parent.setState answered: true
          @props.question.answered = true
        else
          @props.parent.setState answered: false
          @props.question.answered = false

    QuestionFillInputer: React.createClass
      displayName: 'QuestionFillInputer'
      render: ->
        <div className='choices form-inline'>
          {
            for idx in [0...@props.question.fill_count]
              <div className='option' key={idx}>
                <span>{"填空#{NumConv.index_2_cn idx}"}</span>
                <input className='form-control' type='text' onChange={@do_change}/>
              </div>
          }
        </div>

      do_change: (evt)->
        $dom = jQuery(React.findDOMNode @)
        input_arr = $dom.find("input[type='text']").get()
        values = input_arr.map (input)=>
          jQuery(input).val()

        @props.question.answer = values
        if values.indexOf("") == -1
          @props.parent.setState answered: true
          @props.question.answered = true
        else
          @props.parent.setState answered: false
          @props.question.answered = false

    QuestionEssayInputer: React.createClass
      displayName: 'QuestionEssayInputer'
      render: ->
        <div className='choices'>
          <textarea className='form-control' onChange={@do_change} />
        </div>
      do_change: (evt)->
        @props.question.answer = evt.target.value

        if @props.question.answer? and @props.question.answer != ''
          @props.parent.setState answered: true
          @props.question.answered = true
        else
          @props.parent.setState answered: false
          @props.question.answered = false

    QuestionMappingInputer: React.createClass
      displayName: 'QuestionMappingInputer'
      render: ->
        <div className='choices'>
          {
            for left_option, idx in @props.question.left_mapping_options
              <div className='choice' key={idx}>
                <div className='left'>{left_option}</div>
                <select className='form-control' onChange={@do_change}>
                  <option value="">空</option>
                  {
                    right_mapping_options = TestPaperFiller.QuestionMappingInputer.get_show_right_mapping_options(@props.question, left_option)
                    for right_option, idx in right_mapping_options
                      answed_right_mapping_option = TestPaperFiller.QuestionMappingInputer.get_answed_right_mapping_option(@props.question, left_option)
                      if answed_right_mapping_option == right_option
                        <option key={idx} selected="selected" value={right_option}>{right_option}</option>
                      else
                        <option key={idx} value={right_option}>{right_option}</option>
                  }
                </select>
              </div>
          }
        </div>
      do_change: ->
        $dom = jQuery(React.findDOMNode @)
        arr = $dom.find(".choice").get()
        values = []
        answer = {}
        for choice_dom in arr
          left  = jQuery(choice_dom).find(".left").text()
          right = jQuery(choice_dom).find("select").val()
          values.push [left, right] if right != ""

        for value,idx in values
          answer[String(idx)] = value
        @props.question.answer = answer

        if @props.question.answer? && values.length == arr.length
          @props.parent.setState answered: true
          @props.question.answered = true
        else
          @props.parent.setState answered: false
          @props.question.answered = false

      statics:
        get_show_right_mapping_options: (question, left_option)->
          if question.answer == undefined
            return question.right_mapping_options

          answer_hash = {}
          answered_right_options = []
          show_right_mappint_options = []
          for idx,value of question.answer
            answer_hash[value[0]] = value[1]
            answered_right_options.push value[1]

          for right_option in question.right_mapping_options
            if -1 == jQuery.inArray(right_option, answered_right_options) || answer_hash[left_option] == right_option
              show_right_mappint_options.push right_option

          return show_right_mappint_options

        get_answed_right_mapping_option: (question, left_option)->
          return "" if question.answer == undefined

          for idx,value of question.answer
            if value[0] == left_option
              return value[1]

          return ""
