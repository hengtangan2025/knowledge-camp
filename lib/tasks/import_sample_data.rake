namespace :import_sample_data do
  desc "导入用户示例数据"
  task :create_users => [:environment] do
    User.create(:name => "root", :login => "root", :password => "root")
    User.create(:name => "user1", :login => "user1", :password => "1234")
  end

  desc "删除导入的用户示例数据"
  task :remove_users => [:environment] do
    User.where(:name => "root", :login => "root").destroy_all
    User.where(:name => "user1", :login => "user1").destroy_all
  end

  desc "导入示例数据，包括：知识网咯，教程，文件"
  task :create_data => [:create_users] do
    require File.expand_path("../../../sample_data/script/net", __FILE__)
    require File.expand_path("../../../sample_data/script/topic", __FILE__)
    require File.expand_path("../../../sample_data/script/tutorial", __FILE__)
    require File.expand_path("../../../sample_data/script/demo_tutorial", __FILE__)
    require File.expand_path("../../../sample_data/script/sp_tutorial", __FILE__)
    require File.expand_path("../../../sample_data/script/virtual_file", __FILE__)

    ImportSampleData::Net.import
    ImportSampleData::Topic.import
    ImportSampleData::Tutorial.import
    ImportSampleData::SpTutorial.import
    ImportSampleData::DemoTutorial.import
    ImportSampleData::VirtualFile.import
    p "import success!!"
  end

  desc "删除导入的示例数据，包括：知识网咯，教程，文件"
  task :remove_data => [:environment] do
    require File.expand_path("../../../sample_data/script/net", __FILE__)
    require File.expand_path("../../../sample_data/script/topic", __FILE__)
    require File.expand_path("../../../sample_data/script/tutorial", __FILE__)
    require File.expand_path("../../../sample_data/script/demo_tutorial", __FILE__)
    require File.expand_path("../../../sample_data/script/sp_tutorial", __FILE__)
    require File.expand_path("../../../sample_data/script/virtual_file", __FILE__)

    KnowledgeNetPlanStore::Topic.destroy_all
    KnowledgeNetPlanStore::Tutorial.destroy_all
    KnowledgeCamp::Step.destroy_all
    KnowledgeCamp::LearnRecord.destroy_all

    ImportSampleData::Net.nets.each do |net|
      net.plans.destroy_all
      net.points.destroy_all
      net.destroy
    end
    FilePartUpload::FileEntity.destroy_all
    VirtualFileSystem::File.destroy_all
  end

end
