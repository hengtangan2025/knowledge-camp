namespace :blocks do
  desc "为Step下的Block对象设置step_id"
  task :set_step => [:environment] do
    puts "====: 开始设置"
    KnowledgeCamp::Step.each do |step|
      step.blocks.each do |block|
        block.step_id = step.id
        block.save
      end
    end
    puts "====: 设置完毕."
  end
end
