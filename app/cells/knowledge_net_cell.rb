class KnowledgeNetCell < Cell::Rails
  def list
    @nets = KnowledgeNetStore::Net.all.order_by("updated_at DESC")
    render
  end
end