module KnowledgeCampApi
  class NetsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      if !user_signed_in?
        response.headers['WWW-Authenticate'] = 'Basic realm="kc"'
        return render :status => 401, :json => {
          :error => '用户未进行身份验证'
        } 
      end
      result = {
        :nets => [
          {:name => "ruby"}
        ]
      }
      render :json => result
    end
  end
end
