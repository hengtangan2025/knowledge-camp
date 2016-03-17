module PublishMobileDemoTaskMethods
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
    dir = "publish_files/mobile_demo"

    system "cp #{dir}/application.rb            config/"
    system "cp #{dir}/routes.rb                 config/"
    system "cp #{dir}/application_controller.rb app/controllers/"
    system "cp #{dir}/index_controller.rb       app/controllers/"
    system "cp #{dir}/Gemfile                   ./"
    system "cp #{dir}/Gemfile.lock              ./"
  end

  def reserve_files
    _reserve "app/assets/images", %w{
      default_avatars
    }

    _reserve "app/assets/javascripts", %w{
      mockup
      mockup.js
    }

    _reserve "app/assets/stylesheets", %w{
      mockup
      mockup.scss
    }

    _reserve "app/views", %w{
      layouts
      mockup
    }

    _reserve "app/controllers", %w{
      application_controller.rb
      mockup_controller.rb
      index_controller.rb
    }
  end

  def _reserve(from, files)
    Dir.mktmpdir do |tmp|
      files.each do |path|
        system "mv #{File.join from, path} #{tmp}"
      end

      system "rm -rf #{File.join from, '*'}"

      files.each do |path|
        system "mv #{File.join tmp, path} #{from}"
      end
    end
  end

end


namespace :demo do
  include PublishMobileDemoTaskMethods

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

    delete_files
    copy_files
    reserve_files

    Dir.mktmpdir do |tmp|
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