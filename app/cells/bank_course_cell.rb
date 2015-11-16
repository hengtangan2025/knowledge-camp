class BankCourseCell < Cell::Rails

  def one args
    @courses = args[:courses]
    render
  end

  def four args
    @courses = args[:courses]
    render
  end

end
