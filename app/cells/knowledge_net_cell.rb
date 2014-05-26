class KnowledgeNetCell < Cell::Rails
  def list
    @nets = KnowledgeNetStore::Net.all.order_by("updated_at DESC")
    render
  end

  def form(option)
    @net = option[:net]
    if @net.new_record?
      @url = "/knowledge_nets"
      @h2  = "新建知识网络 …"
    else
      @url = "/knowledge_nets/#{@net.id}"
      @h2  = "编辑知识网络 …"
    end

    render
  end
end