module Explore
  class Engine < ::Rails::Engine
    isolate_namespace Explore
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper
    end
  end
end