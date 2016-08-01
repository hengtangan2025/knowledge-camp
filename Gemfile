# coding: utf-8

source "https://ruby.taobao.org"

gem "rails", "4.2.3"
gem 'sass-rails', '~> 5.0'
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "turbolinks"
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

group :development do
  # 去除测试环境 assets提示
  gem 'quiet_assets'
  gem 'pry-rails'
end

group :development, :test do
  gem "spring"
  gem "pry"
  gem "pry-byebug"
end

group :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0'
  gem "database_cleaner", "~> 1.2.0"
end

# -------------

gem "figaro", "~> 1.1.1"
gem "devise", "3.5.2"
gem "kaminari", "~> 0.15.1"
gem 'bootstrap-kaminari-views'
gem "haml"
gem "mongoid", "~> 5.1.3"
gem 'cells', '~> 3.10.1' # 用于复用一些前端组件
gem "simple_form", "~> 3.2.0"
gem "unicorn"
gem "htmldiff"
gem "streamio-ffmpeg"

# -------------

# 中文转拼音
gem 'ruby-pinyin'
# 代码高亮
gem 'haml-coderay'
# 全文搜索
gem "elasticsearch-simple",
  :github => "mindpin/elasticsearch-simple",
  :ref => '9697be2'

gem "mina", "0.3.7"

# tag 管理
gem "knowledge-graph-js",
  :git => "git://github.com/mindpin/knowledge-graph-js.git",
  :tag => "0.0.1"

gem 'knowledge-net-store',
  :git => 'git://github.com/mindpin/knowledge-net-store.git',
  :tag => '1.0.0-beta2'

gem "acts-as-dag",
  :git => "git://github.com/mindpin/acts-as-dag.git",
  :tag => "0.0.3"

gem "knowledge-net-plan-store",
    :github => "mindpin/knowledge-net-plan-store",
    :tag => "v0.1.0.p3"

gem "generic_controller",
    :github => "mindpin/generic_controller",
    :tag => "v0.0.5"

gem "user-auth",
    :github => "mindpin/user-auth",
    :tag => "0.0.8"

gem "sort_char",
    :git => "git://github.com/mindpin/sort_char.git",
    :tag => "0.0.1"

gem "knowledge_camp_step",
    # :path => "../knowledge_camp_step"
    :github => "mindpin/knowledge_camp_step",
    :tag => "0.1.8"

# 文字文档持久化，以下两个 gem 是相关的
gem "mongoid-versioning",
    :github => "simi/mongoid-versioning"

gem "documents-store",
    :github => "mindpin/documents-store",
    :tag => "0.0.5"

gem 'ueditor.rails',
    # :path => '/web/songliang/kaid/ueditor.rails'
    :github => 'mindpin/ueditor.rails',
    # :tag => 'v0.0.5'
    :ref => 'b832fde'

# 解析 UserAgent
# https://github.com/josh/useragent
gem 'useragent'

# 文件上传，用于用户头像逻辑
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
# carrierwave 用到的图片切割
gem "mini_magick", :require => false

# 虚拟文件夹
gem 'virtual_file_system',
    :github => "mindpin/virtual-file",
    :tag => "0.0.7"

# 支持分段上传的文件持久化
gem 'file-part-upload',
  :github => "mindpin/file-part-upload",
  :ref    => "6164fd3"

# 图片加载的一个小工具
gem 'simple-images',
    :github => "mindpin/simple-images",
    :ref => 'fc06f2b'
    # :path => '/web/songliang/simple-images'

gem 'knowledge-camp-api',
    :path => 'vendor/api'

gem 'kc-explore',
    :path => 'vendor/explore',
    :require => 'explore'

gem 'kc-course-editor',
    :path => 'vendor/course_editor',
    :require => 'course_editor'

# -----金融学院相关
gem 'kc_courses', 
                  # :github => 'blackdust/kc_courses',
                  # :ref => "b68e5fc"
                  # :tag => "v0.6.0"
                  :path => "../kc_courses"

gem 'simple-navbar', :github => 'mindpin/simple-navbar',
                     :tag => "0.0.6p1"

gem 'bootstrap-sass', '~> 3.3.5'

gem 'bucketerize', :github => 'mindpin/bucketerize',
                  :ref => "fbcfee9"
                  #:tag => "v0.1.0"

gem 'bank', github: "mindpin/bank", ref: "90d8f54"
gem 'enterprise_position_level', github: "mindpin/enterprise_position_level", ref: "541bf8a"

# 管理组件，2015-12-14改为直接搭建后台
#gem 'engine_manager', github: 'mindpin/engine_manager',
                     #:tag => "v0.0.1"

gem 'question_bank', github: 'mindpin/question_bank',
                     :ref => "455dcc1"

gem 'model_label', github: 'kc-train/model_label',
                    :ref => "596525e"

gem 'kc_comments', github: "mindpin/kc_comments",
                   ref: "5816fb8"

gem 'sprockets', '3.4.0'
gem 'sprockets-rails', '2.3.3'

gem 'react-rails', '1.2.0'
gem 'sprockets-coffee-react', '3.0.1'

# 通过 rails assets 服务加载前端包
source 'https://rails-assets.org'
gem 'rails-assets-semantic'

#http://medialize.github.io/URI.js/
gem 'rails-assets-URIjs'
# http://facebook.github.io/immutable-js/
gem 'rails-assets-immutable'
# https://github.com/Olical/EventEmitter/blob/master/docs/guide.md
gem 'rails-assets-eventEmitter'
