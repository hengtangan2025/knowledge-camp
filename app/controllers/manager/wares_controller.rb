class Manager::WaresController < ApplicationController
  layout "new_version_manager"

  def create
    file_entity_id = ware_params[:file_entity_id]
    if !file_entity_id.blank?
      ware = _new_file_entity_ware
    else
      ware = _new_other_ware
    end

    save_model(ware) do |w|
      DataFormer.new(w)
        .logic(:learned, current_user)
        .url(:url)
        .url(:update_url)
        .url(:move_down_url)
        .url(:move_up_url)
        .url(:delete_url)
        .data
    end
  end

  def update
    ware = KcCourses::Ware.find params[:id]

    update_model(ware, ware_update_params) do |w|
      data = DataFormer.new(w)
        .logic(:learned, current_user)
        .url(:url)
        .url(:update_url)
        .url(:move_down_url)
        .url(:move_up_url)
        .url(:delete_url)
        .data
    end
  end

  def move_up
    ware = KcCourses::Ware.find params[:id]
    ware.move_up
    render :status => 200, :json => {:status => 'success'}
  end

  def move_down
    ware = KcCourses::Ware.find params[:id]
    ware.move_down
    render :status => 200, :json => {:status => 'success'}
  end

  def destroy
    ware = KcCourses::Ware.find params[:id]
    ware.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  def _new_file_entity_ware
    file_entity = FilePartUpload::FileEntity.find ware_params[:file_entity_id]
    attrs = ware_params.merge(chapter_id: params[:chapter_id], creator_id: current_user.id)
    ware = case file_entity.kind
    when 'video'
      KcCourses::SimpleVideoWare.new attrs
    when 'audio'
      KcCourses::SimpleAudioWare.new attrs
    when 'pdf', 'office'
      KcCourses::SimpleDocumentWare.new attrs
    else
      KcCourses::Ware.new attrs
    end
    ware
  end

  def _new_other_ware
    raise "暂不支持"
  end

  private
  def ware_params
    params.require(:ware).permit(:name, :desc, :file_entity_id)
  end

  def ware_update_params
    params.require(:ware).permit(:name, :desc)
  end
end
