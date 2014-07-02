class FileCell < Cell::Rails
  helper :application

  def grid(files)
    @files = files
    render
  end

  def thumbnail(file)
    @file = file
    render
  end
end