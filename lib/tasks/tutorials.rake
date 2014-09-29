namespace :tutorials do
  desc "将所有Tutorial设为已发布"
  task :publish => [:environment] do
    puts "====: 开始设置"
    KnowledgeNetPlanStore::Tutorial.update_all(:published => true)
    puts "====: 设置完毕."
  end
end
