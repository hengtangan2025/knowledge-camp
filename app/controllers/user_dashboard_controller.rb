class UserDashboardController < ApplicationController
  layout "new_version_base"

  def index
    redirect_to "/user_dashboard/my_courses"
  end

  def my_courses
    courses = KcCourses::PublishedCourse.enabled.page(params[:page])
    data = courses.map do |course|
      DataFormer.new(course).url(:url).data
    end

    @page_name = 'user_dashboard_my_courses'
    @component_data = {
      menu: _menu_data,
      current_url: user_dashboard_my_courses_path,
      courses: data,
      paginate: {
        total_pages: courses.total_pages,
        current_page: courses.current_page,
        per_page: courses.limit_value
      }
    }
  end

  def my_notes
    notes = NoteMod::Note.where(creator_id: current_user.id).page(params[:page])
    data = notes.map do |note|
      DataFormer.new(note).logic(:targetable).data
    end

    @page_name = 'user_dashboard_my_notes'
    @component_data = {
      menu: _menu_data,
      current_url: user_dashboard_my_notes_path,
      notes: data,
      paginate: {
        total_pages: notes.total_pages,
        current_page: notes.current_page,
        per_page: notes.limit_value
      }
    }
  end

  def my_questions
    questions = QuestionMod::Question.where(creator_id: current_user.id).page(params[:page])
    data = questions.map do |question|
      DataFormer.new(question).logic(:targetable).data
    end

    @page_name = 'user_dashboard_my_questions'
    @component_data = {
      menu: _menu_data,
      current_url: user_dashboard_my_questions_path,
      questions: data,
      paginate: {
        total_pages: questions.total_pages,
        current_page: questions.current_page,
        per_page: questions.limit_value
      }
    }
  end

  def _menu_data
    [
      {
        name: "我的课程",
        url: user_dashboard_my_courses_path
      },
      {
        name: "我的提问",
        url: user_dashboard_my_questions_path
      },
      {
        name: "我的笔记",
        url: user_dashboard_my_notes_path
      }
    ]
  end
end
