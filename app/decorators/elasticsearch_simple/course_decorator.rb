KcCourses::Course.class_eval do
  include ElasticsearchSimple::Concerns::StandardSearch
  
  standard :name, :desc
end

