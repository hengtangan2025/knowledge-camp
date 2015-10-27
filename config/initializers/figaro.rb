if !File.exists?(Rails.root.join("config/application.yml"))
  p "******************************************"
  p "* 缺少                                   *"
  p "* config/application.yml 配置文件      *"
  p "*                                        *"
  p "* 请参考                                 *"
  p "* config/application.yml.development   *"
  p "* 创建配置文件                           *"
  p "******************************************"

  exit 0
end

if ENV["static_file_url_prefix"].blank?
  p "!请在 config/application.yml 中增加 static_file_url_prefix 配置"
  exit 0
end

if ENV["upload_file_base_path"].blank?
  p "!请在 config/application.yml 中增加 upload_file_base_path 配置"
  exit 0
end
