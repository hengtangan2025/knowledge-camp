class ApplicationController < ActionController::Base
  include GenericController
  protect_from_forgery with: :exception
end
