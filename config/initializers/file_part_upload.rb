require_relative 'rutil'
FilePartUpload.config do
  path RUtil.get_static_file_path("files/:id/file/:name")
  url RUtil.get_static_file_url("files/:id/file/:name")

  image_version :fit500 do
    process :resize_to_fit => [500, 500]
  end

  image_version :fill200 do
    process :resize_to_fill => [200, 200]
  end
end
