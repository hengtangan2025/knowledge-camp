class Manager::WaresController < ApplicationController
  layout "new_version_manager"
  include Data::Former

  def create
    file_entity_id = ware_params[:file_entity_id]
    if !file_entity_id.blank?
      ware = _new_file_entity_ware
    else
      ware = _new_other_ware
    end

    if ware.save
      render json: manager_wares_create_response_data(ware)
    else
      render json: ware.errors.messages, status: 422
    end
  end

  def _new_file_entity_ware
    file_entity = FilePartUpload::FileEntity.find ware_params[:file_entity_id]
    attrs = ware_params.merge(chapter_id: params[:id], creator_id: current_user.id)
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
    params.require(:ware).permit(:title, :desc, :file_entity_id)
  end
end
