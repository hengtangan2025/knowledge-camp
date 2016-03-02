class Old::Manage::FilesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @net = KnowledgeNetStore::Net.find params[:net_id]
  end

  def index
    @net = KnowledgeNetStore::Net.find params[:net_id]
    @virtual_files = @net.virtual_files.unscoped.order_by(:updated_at => :desc)
  end

  def create
    @net = KnowledgeNetStore::Net.find params[:net_id]
    
    params[:files].each do |file_entity_id, visible_filename|
      virtual_filename = get_virtual_filename(visible_filename)

      command = VirtualFileSystem::Command(:knowledge_net , current_user)
      command.put("/" + virtual_filename, file_entity_id, :mode => :default) do |vff|
        vff.net = @net
        vff.visible_name = visible_filename
      end
    end

    render :text => ''
  end

  def show
    @virtual_file = VirtualFileSystem::File.find params[:id]
  end
end
