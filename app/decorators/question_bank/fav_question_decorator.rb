QuestionBank::Question.class_eval do
  include Bucketerize::Concerns::Resource
  act_as_bucket_resource mode: :standard
end

QuestionBank::TestPaper.class_eval do
  def react_data
    {
      id: id.to_s,
      title: title,
      score: score,
      minutes: minutes,
      sections: sections.map(&:react_data)
    }
  end
end

QuestionBank::Section.class_eval do
  def react_data
    {
      id: id.to_s,
      kind_text: kind.text,
      score: score,
      questions: questions.map(&:react_data)
    }
  end
end

QuestionBank::Question.class_eval do
  def react_data
    {
      id: id.to_s,
      kind: kind,
      content: content,
      choices: choices,
      fill_count: fill_count,
      left_mapping_options: left_mapping_options,
      right_mapping_options: right_mapping_options
    }
  end
end
