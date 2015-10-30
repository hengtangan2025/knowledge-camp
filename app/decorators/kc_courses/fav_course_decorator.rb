KcCourses::Course.class_eval do
  include Bucketerize::Concerns::Resource
  act_as_bucket_resource into: :'bucketerize/bucket'
end

Bucketerize::Bucket.class_eval do
  act_as_bucket collect: :"kc_courses/course"
end
