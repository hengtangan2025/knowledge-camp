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

  qiniu_audio_and_video_transcode :enable
end