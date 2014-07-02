FilePartUpload.config do
  image_version :fit500 do
    process :resize_to_fit => [500, 500]
  end

  image_version :fill200 do
    process :resize_to_fill => [200, 200]
  end
end