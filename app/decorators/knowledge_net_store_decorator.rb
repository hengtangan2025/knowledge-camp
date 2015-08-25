p "knowledge_net_store_decorator.rb load"
module KnowledgeNetStore
  class Net
    has_many :virtual_files,
             :class_name => 'VirtualFileSystem::File',
             :dependent => :destroy
  end

  class Point
    has_and_belongs_to_many :virtual_files,
                            :class_name => 'VirtualFileSystem::File',
                            :inverse_of => :points

    has_and_belongs_to_many :questions,
                            :class_name => 'QuestionBank::Question',
                            :inverse_of => :points

    has_and_belongs_to_many :wares,
                            :class_name => 'KcCourses::Ware',
                            :inverse_of => :points
  end
end

[
  KnowledgeNetStore::Net,
  VirtualFileSystem::File
].each do |klass|
  klass.send :include, Kaminari::MongoidExtension::Document
end

p "knowledge_net_store_decorator.rb load success"
