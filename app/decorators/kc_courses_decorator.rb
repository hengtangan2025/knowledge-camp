p "kc_courses_decorator.rb load"
module KcCourses
  class Ware
    has_and_belongs_to_many :points,
                            :class_name => 'KnowledgeNetStore::Point',
                            :inverse_of => :wares
  end
end
p "kc_courses_decorator.rb load success"
