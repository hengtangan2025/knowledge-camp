namespace :pinyin do
  desc "导入开启拼音搜索功能模型的索引"
  task :index => [:environment] do
    PinyinSearch.enabled_models.each do |model|
      puts "---- 开始导入 model.to_s 的拼音索引"
      model.import :force => true
      puts "---- 倒入完毕"
    end
  end
end
