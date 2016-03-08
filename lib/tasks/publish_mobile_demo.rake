module PublishTaskMethods
  def get_current_branch_name
    output = `git branch`
    return output.lines.map(&:strip).select { |x|
      x[0] == '*'
    }.first.split('* ').last
  end

  def delete_files
    %w{
      app/cells
      app/decorators
      app/helpers
      app/mailers
      app/models
      app/uploaders

      app/assets/images

      config/initializers/gem_integration.rb
      config/initializers/devise.rb
      config/initializers/figaro.rb
      config/initializers/kaminari_config.rb
      config/initializers/simple_form_bootstrap.rb
      config/initializers/simple_form.rb
    }.each do |path|
      system "rm -rf #{path}"
    end
  end

  def copy_files
    system "cp demo_files/application.rb config/"
    system "cp demo_files/routes.rb config/"
    system "cp demo_files/application_controller.rb app/controllers/"
    system "cp demo_files/index_controller.rb app/controllers/"
    system "cp demo_files/Gemfile ./"
    system "cp demo_files/Gemfile.lock ./"
  end

  def move_files
    _move "app/assets/javascripts", %w{
      mockup
      mockup.js
    }

    _move "app/assets/stylesheets", %w{
      mockup
      mockup.scss
    }

    _move "app/views", %w{
      layouts
      mockup
    }

    _move "app/controllers", %w{
      application_controller.rb
      mockup_controller.rb
    }
  end

  def _move(from, files)
    files.each do |path|
      system "mv #{File.join from, path} demo_files/"
    end

    system "rm -rf #{File.join from, '*'}"

    files.each do |path|
      system "mv #{File.join "demo_files", path} #{from}"
    end
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
    puts '处理文件 …'
    Dir.mktmpdir do |tmp|
      delete_files
      copy_files
      move_files

      %w{
        app
        bin
        config
        public
        tmp

        Gemfile
        Gemfile.lock
        config.ru
        Rakefile
      }.each do |path|
        system "mv #{path} #{tmp}"
      end

      system "git checkout ."
      system "git checkout -B mobile-demo"
      system "rm -rf *"

      system "mv #{tmp}/* ."

      message = "Site updated at #{Time.now.utc}"
      system "git add ."
      system "git commit -am #{message.shellescape}"
      system "git push origin mobile-demo --force"
      system "git push coding mobile-demo --force"
      system "git checkout mobile-mockup"
      system "git submodule update"
      puts "发布完毕"
    end
  end
  
end