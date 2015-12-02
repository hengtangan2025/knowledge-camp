class BankCourseCell < Cell::Rails
  include Devise::Controllers::Helpers
  helper_method :current_user #all your needed helper

  def one args
    @courses = args[:courses]
    render
  end

  def one_detail args
    @course = args[:course]
    @show_share_and_fav = args[:show_share_and_fav]
    @percent = current_user ? @course.read_percent_of_user(current_user) : 0
    render
  end

  def four args
    @courses = args[:courses]
    render
  end

  def content args
    @course = args[:course]
    render
  end

  def chapters args
    @course = args[:course]
    @chapters = @course.chapters.includes(:wares)
    render
  end

  def data args
    @course = args[:course]
    render
  end

  def related args
    @course = args[:course]
    render
  end

  def index args
    @courses = args[:courses]
    render
  end

end
