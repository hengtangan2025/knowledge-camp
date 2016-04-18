def randstr(length=8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  size = base.size
  re = '' << base[rand(size-10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  re
end

def get_virtual_filename(filename)
  filename = filename.to_s
  return "" if filename.blank?
  arr = filename.split(".")
  return "#{filename}-#{randstr(32)}" if arr.count == 1

  extname = arr.pop
  return "#{arr*"."}-#{randstr(32)}.#{extname}"
end

class RUtil
  class << self
    def get_static_file_url(path)
      File.join('/', ENV["static_file_url_prefix"], path)
    end

    def get_static_file_path(path)
      File.join('/', ENV["upload_file_base_path"], path)
    end
  end
end

FilePartUpload.config do
  mode :qiniu

  qiniu_bucket         ENV["qiniu_bucket"]
  qiniu_domain         ENV["qiniu_domain"]
  qiniu_base_path      ENV["qiniu_base_path"]
  qiniu_app_access_key ENV["qiniu_app_access_key"]
  qiniu_app_secret_key ENV["qiniu_app_secret_key"]
  qiniu_callback_host  ENV["qiniu_callback_host"]

  qiniu_audio_and_video_transcode(ENV["qiniu_audio_and_video_transcode"] || :enable)
  qiniu_pfop_pipeline  ENV["qiniu_pfop_pipeline"]
end

FilePartUpload.config do
  path RUtil.get_static_file_path("files/:id/file/:name")
  url RUtil.get_static_file_url("files/:id/file/:name")
end

class MindpinHTMLDiff
  class << self
    include HTMLDiff
  end
end

# -----------------------------------------
# virtual_file_system 相关
module FileEntityVFSModule
  def get_uri(store_id)
    {
      :type => :disk,
      :value => FilePartUpload::FileEntity.find(store_id).attach.path
    }
  end

  def file_info(store_id)
    fe = FilePartUpload::FileEntity.find(store_id)
    {
      :size => fe.file_size,
      :mime_type => fe.mime, # MIME TYPE
      :mime_type_info => {}
    }
  end
end
