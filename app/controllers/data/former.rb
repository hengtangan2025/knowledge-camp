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
      manager_contents_url: organize_manager_course_path(course)
    }
  end
end
