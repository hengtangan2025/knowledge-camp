p "question_bank_decorator.rb load"
module QuestionBank
  class Question
    has_and_belongs_to_many :points,
                            :class_name => 'KnowledgeNetStore::Point',
                            :inverse_of => :questions
  end
end
p "question_bank_decorator.rb load success"
