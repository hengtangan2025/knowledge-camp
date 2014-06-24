class DocumentCell < Cell::Rails
  helper :application

  def grid(documents)
    @documents = documents
    render
  end

  def version_info(document)
    @document = document
    @last_editor = document.last_editor
    render
  end

  # current_version 是 version 对象而不是编号
  def versions_list(document, current_version)
    @document = document
    @current_version = current_version
    @vers = [document] + document.versions
    render
  end
end