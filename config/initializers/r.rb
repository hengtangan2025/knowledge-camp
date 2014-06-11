HASH = {
  :static_file_base_path_prefix => "public"
}

class R
  STATIC_FILE_URL_PREFIX = "static_files"

  UPLOAD_FILE_BASE_PATH = File.join(
    File.expand_path(HASH[:static_file_base_path_prefix], Rails.root),
      STATIC_FILE_URL_PREFIX    
    )
end