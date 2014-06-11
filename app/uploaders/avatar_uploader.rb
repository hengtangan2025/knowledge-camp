class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ImageUploaderMethods

  # 存储方式 本地硬盘存储
  storage :file

  # 当文件不存在时的默认 url
  def default_url
    version__name = self.version_name.blank? ? "avatar_200" : self.version_name
    # For Rails 3.1+ asset pipeline compatibility:
    #ActionController::Base.helpers.asset_path("assets/images/fallback/" + [version_name, "default.png"].compact.join('_'))
    "/assets/default_avatars/#{version__name}.png"
  end

  # 图片裁剪
  version :large do
    process :resize_to_fill => [180, 180]
  end
  version :normal do
    process :resize_to_fill => [64, 64]
  end
  version :small do
    process :resize_to_fill => [30, 30]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # 自定义裁切的逻辑，暂时用不到
  # process :cropper
  # def cropper
  #   manipulate! do |img|
  #     img.crop("#{model.avatar_cw}x#{model.avatar_ch}+#{model.avatar_cx}+#{model.avatar_cy}")
  #     img = yield(img) if block_given?
  #     img
  #   end
  # end

end
