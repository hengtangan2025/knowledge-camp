module CourseEditor
  class Engine < ::Rails::Engine
    isolate_namespace CourseEditor
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper
    end
  end
end