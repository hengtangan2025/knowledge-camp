module KnowledgeCampApi
  class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :check_auth

    rescue_from Mongoid::Errors::DocumentNotFound, :with => :not_found

    protected

    def not_found
      error NotFound.new
    end

    def display(obj, status=200)
      render :json => data(obj), :status => status
    end

    def data(obj)
      case obj
      when Hash then obj
      when Array, Mongoid::Criteria then obj.map(&:attrs)
      when Error, Mongoid::Document then obj.attrs
      end
    end

    def error(error)
      display error, error.status
    end

    def check_auth
      if !user_signed_in?
        response.headers['WWW-Authenticate'] = 'Basic realm="kc"'

        return error Unauthorized.new
      end
    end
  end
end
