class BankCourseCell < Cell::Rails

  def one args
    @courses = args[:courses]
    render
  end

  def one_detail args
    @course = args[:course]
    @show_share_and_fav = args[:show_share_and_fav]
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

end
