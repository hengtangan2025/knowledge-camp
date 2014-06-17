class UploadController < ApplicationController
  def upload
    chunk_number = params[:resumableChunkNumber]
    file_name = params[:resumableFilename]
    file_size = params[:resumableTotalSize]
    identifier = params[:resumableIdentifier]

    if chunk_number.to_i == 1
      # 新文件
      file_entity = FilePartUpload::FileEntity.new(
        :attach_file_name => file_name, 
        :attach_file_size => file_size
      )

      file_entity.save
      session[identifier] = file_entity.id.to_s
    else
      # 增量上传
      file_entity_id = session[identifier]
      file_entity = FilePartUpload::FileEntity.find(file_entity_id)
    end

    file_entity.save_blob params[:file]

    render :json => {
      :file_entity_id => file_entity.id.to_s
    }
  end
end