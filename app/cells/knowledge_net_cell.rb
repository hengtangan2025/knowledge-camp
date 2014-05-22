class KnowledgeNetCell < Cell::Base
  def list
    @nets = KnowledgeNetStore::Net.all.order_by("updated_at DESC")
    render
  end
end