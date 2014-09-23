namespace :learn do
  desc "生成当前用户的学习进度"
  task :progress => [:environment] do
    puts "====: 开始生成学习进度"
    KnowledgeCamp::LearnRecord.each(&:update_tutorial_progress!)
    TutorialLearnProgress.each(&:update_topic_progress!)
    puts "====: 生成完毕."
  end
end
