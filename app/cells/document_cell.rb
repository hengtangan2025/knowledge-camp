class DocumentCell < Cell::Rails
  helper :application

  def grid(documents)
    @documents = documents
    render
  end
end