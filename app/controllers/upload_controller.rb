class UploadController < ApplicationController
  # GET /upload
  def check
    identifier = params[:flowIdentifier]

    # 尝试根据唯一标识找到文件
    file_entity = FilePartUpload::FileEntity.where({
      :identifier => identifier
    }).first

    if file_entity.blank?
      render :status => 404, :text => 'file_entity is not exist.'
      return
    end

    chunk_number        = params[:flowChunkNumber].to_i
    chunk_size          = params[:flowChunkSize].to_i
    current_chunk_size  = params[:flowCurrentChunkSize].to_i

    saved_size = file_entity.saved_size
    current_uploading_size = (chunk_number - 1) * chunk_size + current_chunk_size


    if current_uploading_size > saved_size
      render :status => 404, :text => 'chunk is not uploaded'
    else
      render :nothing => true, :status => 200
    end
  end

  # POST /upload
  def upload
    file_name  = params[:flowFilename]
    file_size  = params[:flowTotalSize].to_i
    identifier = params[:flowIdentifier]

    # 尝试根据唯一标识找到文件
    file_entity = FilePartUpload::FileEntity.where(
        :identifier => identifier).first

    # 如果不存在，就创建一个
    if file_entity.blank?
      file_entity = FilePartUpload::FileEntity.new(
        :attach_file_name => file_name, 
        :attach_file_size => file_size,
        :identifier => identifier
      )
    end

    file_entity.save_blob params[:file]

    render :json => {
      :file_entity_id => file_entity.id.to_s
    }
  end
end