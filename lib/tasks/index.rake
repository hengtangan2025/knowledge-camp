namespace :index do
  desc "导入相关模型的ElasticSearch索引"
  task :import => [:environment] do
    Searchable.enabled_models.each do |model|
      puts "====: 开始导入 #{model.to_s} 的索引"
      model.import :force => true
      model.each(&:save)
      puts "====: 导入完毕."
    end
  end
end
