module Data::Former
  def manager_courses_component_data
    courses = KcCourses::Course.all.page(params[:page])

    data = courses.map do |course|
      {
        id: course.id.to_s,
        img: course.cover,
        name: course.title,
        desc: course.desc,
        instructor: course.creator.name,
        manager_contents_url: organize_manager_course_path(course)
      }
    end

    {
      new_course_url: new_manager_course_path,
      courses: data,
      paginate: {
        total_pages: courses.total_pages,
        current_page: courses.current_page,
        per_page: courses.limit_value
      },
      # 用于生成顶部过滤
      filter_subjects: [
        {name: '电子商务', id: '1'},
        {name: '农产品销售', id: '2'},
      ],
    }
  end

  def manager_courses_create_response_data(course)
    {
      id: course.id.to_s,
      img: course.cover,
      name: course.title,
      desc: course.desc,
      instructor: course.creator.name,
      jump_url: organize_manager_course_path(course)
    }
  end

  def manager_course_contents_component_data(course)
    video_count = course.statistic_info[:video][:count]
    total_minute = course.statistic_info[:video][:total_minute]

    {
      id: course.id.to_s,
      img: course.cover,
      name: course.title,
      desc: course.desc,
      instructor: course.creator.name,
      subjects: course.course_subjects.map{|subject| {name: subject.name, url: subject_path(subject.id.to_s)}},
      price: '免费',
      effort: "#{video_count} 个视频，合计 #{total_minute} 分钟",
      chapters: course.chapters.map{|chapter| _chapter_data(chapter) }
    }
  end

  def manager_chapters_create_response_data(chapter)
    {
      id: chapter.id.to_s,
      name: chapter.title,
      desc: chapter.desc,
      move_down_url: move_down_manager_chapter_path(chapter)
    }
  end

  def manager_chapters_update_response_data(chapter)
    {
      id: chapter.id.to_s,
      name: chapter.title,
      desc: chapter.desc
    }
  end

  def _chapter_data(chapter)
    {
      id: chapter.id.to_s,
      name: chapter.title,
      wares: chapter.wares.map{|ware|  _ware_data(ware) }
    }
  end

  def _ware_data(ware)
    percent = ware.read_percent_of_user(controller.current_user)
    learned = 'done' if percent == 100
    learned = 'half' if percent > 0 && percent < 100
    learned = 'no'   if percent == 0

    data = {
      id: ware.id.to_s,
      name: ware.title,
      url: ware_path(ware.id.to_s),
      kind: ware._type,
      learned: learned,
    }

    data[:kind] = "document"
    if ware._type == "KcCourses::SimpleAudioWare"
      data[:kind] = "audio"
      seconds = ware.file_entity.meta[:audio][:audio_duration].to_i
      data[:time] = "#{seconds/60}′#{seconds%60}″"
    end

    if ware._type == "KcCourses::SimpleVideoWare"
      data[:kind] = "video"
      seconds = ware.file_entity.meta[:video][:total_duration].to_i
      data[:time] = "#{seconds/60}′#{seconds%60}″"
      data[:video_url] = ware.file_entity.transcode_url("超请") ||
        ware.file_entity.transcode_url("高请") ||
        ware.file_entity.transcode_url("标清") ||
        ware.file_entity.transcode_url("低清")
    end

    data
  end
end
