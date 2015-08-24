# 检查 application.yml 是否存在
if !File.exists?(Rails.root.join("config/application.yml"))
  p "******************************************"
  p "* 缺少                                    *"
  p "* config/application.yml 配置文件          *"
  p "*                                        *"
  p "* 请参考                                  *"
  p "* config/application.yml.example         *"
  p "* 创建配置文件                             *"
  p "******************************************"

  exit 0
end

# 检查必要的配置项，如果没有，不允许工程启动
begin
  flag = true

  if ENV['STATIC_FILE_URL_PREFIX'].blank?
    flag = false
    p "*! 找不到配置: STATIC_FILE_URL_PREFIX"
  end

  if !defined? ENV['UPLOAD_FILE_BASE_PATH']
    flag = false
    p "*! 找不到配置: UPLOAD_FILE_BASE_PATH"
  end

  exit(0) if !flag
end

class RUtil
  class << self
    def get_static_file_url(path)
      File.join('/', ENV['STATIC_FILE_URL_PREFIX'], path)
    end

    def get_static_file_path(path)
      File.join('/', ENV['UPLOAD_FILE_BASE_PATH'], path)
    end
  end
end
