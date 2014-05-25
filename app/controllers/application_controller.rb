require "cell/rails/helper_api" # cell helpers for simlpe_form, etc..

class ApplicationController < ActionController::Base
  include GenericController
  protect_from_forgery with: :exception
end
