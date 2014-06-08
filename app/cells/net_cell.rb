class NetCell < Cell::Rails
  def grid(option = {})
    @nets = KnowledgeNetStore::Net.all
    render
  end
end