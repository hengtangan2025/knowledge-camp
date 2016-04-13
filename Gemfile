# coding: utf-8

ruby '2.1.3'

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
gem "mongoid", "~> 4.0.0"
gem "bson_ext"
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

gem "mina", "0.3.7"

gem "generic_controller",
    :github => "mindpin/generic_controller",
    :tag => "v0.0.5"

gem "user-auth",
    :github => "mindpin/user-auth",
    :tag => "0.0.8"

gem "sort_char",
    :git => "git://github.com/mindpin/sort_char.git",
    :tag => "0.0.1"

# 解析 UserAgent
# https://github.com/josh/useragent
gem 'useragent'

# 支持分段上传的文件持久化
gem 'file-part-upload',
    :github => "mindpin/file-part-upload",
    :ref    => "fd69106"

# -----金融学院相关
gem 'kc_courses', :github => 'fushang318/kc_courses',
                  :ref => "5cb25c0"

gem 'bank', github: "mindpin/bank", ref: "e3de6cb"
gem 'enterprise_position_level', github: "mindpin/enterprise_position_level", ref: "93b2eff"

gem 'sprockets', '3.4.0'
gem 'sprockets-rails', '2.3.3'

gem 'react-rails', '1.2.0'
gem 'sprockets-coffee-react', '3.0.1'

# 控制台
gem 'web-console', '~> 2.0'

# 通过 rails assets 服务加载前端包
source 'https://rails-assets.org'
gem 'rails-assets-semantic'

#http://medialize.github.io/URI.js/
gem 'rails-assets-URIjs'
# http://facebook.github.io/immutable-js/
gem 'rails-assets-immutable'
# https://github.com/Olical/EventEmitter/blob/master/docs/guide.md
gem 'rails-assets-eventEmitter'
