class Folder
  include Bucketerize::Concerns::Bucket
  act_as_bucket collect: :"kc_courses/course"
end

KcCourses::Course.class_eval do
  include Bucketerize::Concerns::Resource
  act_as_bucket_resource into: :folder
end


User.class_eval do
  has_many :folders
end
