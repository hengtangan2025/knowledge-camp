if !defined? RUtil

  # 检查 r.rb 是否存在
  if !File.exists?(Rails.root.join("config/initializers/r.rb"))
    p "******************************************"
    p "* 缺少                                   *"
    p "* config/initializers/r.rb 配置文件      *"
    p "*                                        *"
    p "* 请参考                                 *" 
    p "* config/initializers/r.rb.development   *"
    p "* 创建配置文件                           *"
    p "******************************************"

    exit 0
  end

  require_relative 'r'

  # 检查必要的配置项，如果没有，不允许工程启动
  begin
    flag = true
    
    if !defined? R::STATIC_FILE_URL_PREFIX
      flag = false
      p "*! 找不到配置: R::STATIC_FILE_URL_PREFIX"
    end

    if !defined? R::UPLOAD_FILE_BASE_PATH
      flag = false
      p "*! 找不到配置: R::UPLOAD_FILE_BASE_PATH"
    end

    exit(0) if !flag
  end

  # 检查非必要配置项
  begin
    if !defined? R::ALIYUN_OSS_ACCESS_KEY_ID
      p "*! 找不到配置: R::ALIYUN_OSS_ACCESS_KEY_ID"
      p " ! 阿里云存储模块无法使用"
    end

    if !defined? R::ALIYUN_OSS_ACCESS_KEY_SECRET
      p "*! 找不到配置: R::ALIYUN_OSS_ACCESS_KEY_SECRET"
      p " ! 阿里云存储模块无法使用"
    end

    if !defined? R::ALIYUN_OSS_HOST
      p "*! 找不到配置: R::ALIYUN_OSS_HOST"
      p " ! 阿里云存储模块无法使用"
    end

    if !defined? R::ALIYUN_OSS_BUCKET_NAME
      p "*! 找不到配置: R::ALIYUN_OSS_BUCKET_NAME"
      p " ! 阿里云存储模块无法使用"
    end

  end

  class RUtil
    class << self
      def get_static_file_url(path)
        File.join('/', R::STATIC_FILE_URL_PREFIX, path)
      end

      def get_static_file_path(path)
        File.join('/', R::UPLOAD_FILE_BASE_PATH, path)
      end

      def get_aliyun_oss_access_key_id
        R::ALIYUN_OSS_ACCESS_KEY_ID
      end

      def get_aliyun_oss_access_key_secret
        R::ALIYUN_OSS_ACCESS_KEY_SECRET
      end

      def get_aliyun_oss_host
        R::ALIYUN_OSS_HOST
      end

      def get_aliyun_oss_bucket_name
        R::ALIYUN_OSS_BUCKET_NAME
      end
    end
  end

end