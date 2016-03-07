module PublishTaskMethods
  def get_current_branch_name
    output = `git branch`
    return output.lines.map(&:strip).select { |x|
      x[0] == '*'
    }.first.split('* ').last
  end
end


namespace :demo do
  include PublishTaskMethods
  # ben7th
  # 2016-03-07
  # 根据 mobile-mockup 分支清理代码，并发布到 mobile-demo 分支

  desc "根据 mobile-mockup 分支清理代码，并发布到 mobile-demo 分支"
  task :publish_mobile => [:environment] do
    current_branch = get_current_branch_name

    if current_branch != 'mobile-mockup'
      puts '必须在 mobile-mockup 分支下发布'
      exit
    end

    puts '开始发布 …'
  end

end