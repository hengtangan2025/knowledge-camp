module Explore
  class ApplicationController < ActionController::Base
    def mobile?
      ua = request.user_agent.to_s.downcase
      return true if ua =~ /iphone/
      return true if ua =~ /android/
      return false
    end
  end
end