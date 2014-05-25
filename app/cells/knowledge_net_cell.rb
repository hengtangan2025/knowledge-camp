class KnowledgeNetCell < Cell::Rails
  def list
    @nets = KnowledgeNetStore::Net.all.order_by("updated_at DESC")
    render
  end

  def form(option)
    @net = option[:net]
    @url = @net.new_record? ? "/knowledge_nets" : "/knowledge_nets/#{@net.id}"
    render
  end
end