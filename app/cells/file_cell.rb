class FileCell < Cell::Rails
  helper :application

  def grid(files)
    @files = files
    render
  end
end