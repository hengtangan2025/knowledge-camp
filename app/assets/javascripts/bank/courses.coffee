jQuery(document).on 'ready page:load', ->
  jQuery('.page-course-study').on 'click', '.intro-button', ->
    jQuery(this).popover('toggle')

  class CourseChaptersReadingProgress
    before_load: ($el)->
    loaded: ($el, data) ->
      @render_course_chapters($el, data)

    error: ($el, data) ->
      #alert '出错拉,请刷新重试'
    finally: ($el)->

    render_course_chapters: ($el, data) ->
      # 章节列表start
      $.each data.chapters, (index) ->
        if this.wares.length > 0
          $.each this.wares, (ware_index) ->
            $el.find(".chapter-ware[data-ware-id=#{this.id}] .progress-bar").css('width', "#{this.percent}%") if this.percent > 0
            $el.find(".chapter-ware[data-ware-id=#{this.id}] .studied").show() if this.percent == 100

      if data.current_ware and data.current_ware.id
        $el.find(".chapter-ware[data-ware-id=#{data.current_ware.id}] .ware-action .continue_study").show()
      else
        $el.find('.start_study').first().show() if this.percent == 0
      # 章节列表end

  configs = 
    progress_class: CourseChaptersReadingProgress
    selector: '.page-course-show'

  if jQuery('.page-course-show').length > 0
    window.ware_reading = new WareReading(configs)
    window.ware_reading.load()

  class StudyChaptersReadingProgress
    before_load: ($el)->
    loaded: ($el, data) ->
      @render_course_chapters($el, data)

    error: ($el, data) ->
      #alert '出错拉,请刷新重试'
    finally: ($el)->

    render_course_chapters: ($el, data) ->
      # 章节列表start
      $.each data.chapters, (index) ->
        if this.wares.length > 0
          $.each this.wares, (ware_index) ->
            $el.find(".chapter-ware[data-ware-id=#{this.id}] .studied").show() if this.percent == 100

      if data.current_ware and data.current_ware.id
        $el.find(".chapter-ware[data-ware-id=#{data.current_ware.id}] .progress-bar").css('width', "100%")
        $el.find(".chapter-ware[data-ware-id=#{data.current_ware.id}] .ware-action .studying").show()
      else
        $el.find('.studying').first().show() if this.percent == 0
      # 章节列表end

  study_configs = 
    progress_class: StudyChaptersReadingProgress
    selector: '.page-course-study'

  if jQuery('.page-course-study').length > 0
    window.ware_reading = new WareReading(study_configs)
    window.ware_reading.load()

  class CourseOneDetailReadingProgress
    before_load: ($el)->
    loaded: ($el, data) ->
      console.log 'CourseOneDetailReadingProgress loaded'
      console.log $el
      console.log data
      @render_course($el, data)

    error: ($el, data) ->
      #alert '出错拉,请刷新重试'
    finally: ($el)->

    render_course: ($el, data) ->
      # 课程详情 start
      if data.current_ware
        $el.find('.current-ware-title').html(data.current_ware.title)
        $el.find('.continue_study, .to').show()
        jQuery('.progress-info').show()
      else
        if data.percent == 100
          $el.find('.studied').show()
        else
          $el.find('.start_study').show()

      if data.percent > 0
        $el.find('.cost, .last').show()

      $el.find('.progress-bar').css('width', "#{data.percent}%")
      $el.find('.course-spent-time').html(data.str_spent_time)
      if data.last_studied_at
        date = new Date(data.last_studied_at)
        $el.find('.course-last-studied-at').html(date.toLocaleString())

      # 课程详情 end

  one_detail_configs = 
    progress_class: CourseOneDetailReadingProgress
    selector: '.course-one-detail'

  if jQuery('.course-one-detail').length > 0
    window.ware_reading = new WareReading(one_detail_configs)
    window.ware_reading.load()
