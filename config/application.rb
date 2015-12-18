# coding: utf-8
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
require "elasticsearch/rails/instrumentation"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "ueditor.rails"

module KnowledgeCamp
  class Application < Rails::Application
    config.assets.precompile += ['ueditor/iframe.css','bank.css','bank.js']

    # 时区，国际化
    config.time_zone = 'Beijing'
    config.i18n.default_locale = 'zh-CN'.to_sym
    config.encoding = 'utf-8'
    config.autoload_paths += %W(#{config.root}/lib)

    config.assets.precompile += %w( explore/web.css )
  end
end
