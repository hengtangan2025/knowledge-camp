class Manage::FilesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @net = KnowledgeNetStore::Net.find params[:net_id]
  end

  def index
    @net = KnowledgeNetStore::Net.find params[:net_id]
    @virtual_files = @net.virtual_files
  end
end