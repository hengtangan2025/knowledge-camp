class Manage::DocumentsController < BaseGenericController
  set_model DocumentsStore::Document,
    :allow_attrs  => []

  def index
    @net = KnowledgeNetStore::Net.find params[:net_id]
    @documents = []
  end

  def new
    @net = KnowledgeNetStore::Net.find params[:net_id]
  end
end