jQuery(document).on 'ready page:load', ->
  jQuery('.page-course-study').on 'click', '.intro-button', ->
    jQuery(this).popover('toggle')

  class CourseChaptersReadingProgress
    before_load: ($el)->
      console.log 'before_load'
      console.log $el
    loaded: ($el, data) ->
      console.log 'loaded'
      @render_course_chapters($el, data)

    error: ($el, data) ->
      console.log data
      #alert '出错拉,请刷新重试'
    finally: ($el)->
      console.log 'finally'
      console.log $el

    render_course_chapters: ($el, data) ->
      # 章节列表start
      $.each data.chapters, (index) ->
        if this.wares.length > 0
          $.each this.wares, (ware_index) ->
            $el.find(".chapter-ware[data-ware-id=#{this.id}] .progress-bar").css('width', "#{this.percent}%") if this.percent > 0
            $el.find(".chapter-ware[data-ware-id=#{this.id}] .studied").show() if this.percent == 100

      if data.current_ware_id
        $el.find(".chapter-ware[data-ware-id=#{data.current_ware_id}] .ware-action .continue_study").show()
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
      console.log 'before_load'
      console.log $el
    loaded: ($el, data) ->
      console.log 'loaded'
      @render_course_chapters($el, data)

    error: ($el, data) ->
      console.log data
      #alert '出错拉,请刷新重试'
    finally: ($el)->
      console.log 'finally'
      console.log $el

    render_course_chapters: ($el, data) ->
      # 章节列表start
      $.each data.chapters, (index) ->
        if this.wares.length > 0
          $.each this.wares, (ware_index) ->
            $el.find(".chapter-ware[data-ware-id=#{this.id}] .studied").show() if this.percent == 100

      console.log data.current_ware_id
      console.log 'data.current_ware_id'

      if data.current_ware_id
        $el.find(".chapter-ware[data-ware-id=#{data.current_ware_id}] .progress-bar").css('width', "100%")
        $el.find(".chapter-ware[data-ware-id=#{data.current_ware_id}] .ware-action .studying").show()
      else
        $el.find('.studying').first().show() if this.percent == 0
      # 章节列表end

  study_configs = 
    progress_class: StudyChaptersReadingProgress
    selector: '.page-course-study'

  if jQuery('.page-course-study').length > 0
    window.ware_reading = new WareReading(study_configs)
    window.ware_reading.load()
