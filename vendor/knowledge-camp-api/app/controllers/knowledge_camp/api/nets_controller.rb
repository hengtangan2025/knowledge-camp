module KnowledgeCamp
  module Api
    class NetsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        if !user_signed_in?
          return render :status => 401, :text => 401
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
end
