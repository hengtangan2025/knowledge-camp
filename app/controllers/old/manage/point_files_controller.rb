class Manage::PointFilesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @point = KnowledgeNetStore::Point.find params[:point_id]
    @net = @point.net
  end

  def index
    @point = KnowledgeNetStore::Point.find params[:point_id]
    redirect_to [:old, :manage, @point]
  end

  def create
    @point = KnowledgeNetStore::Point.find params[:point_id]
    @net = @point.net
    
    params[:files].each do |file_entity_id, visible_filename|
      virtual_filename = get_virtual_filename(visible_filename)

      command = VirtualFileSystem::Command(:knowledge_net , current_user)
      command.put("/" + virtual_filename, file_entity_id, :mode => :default) do |vff|
        vff.net = @net
        vff.point_ids << @point.id
        vff.visible_name = visible_filename
      end
    end

    render :text => ''
  end
end
