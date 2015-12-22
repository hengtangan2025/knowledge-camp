QuestionBank::Question.class_eval do
  include Bucketerize::Concerns::Resource
  act_as_bucket_resource mode: :standard
end
