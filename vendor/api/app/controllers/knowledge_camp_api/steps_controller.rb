module KnowledgeCampApi
  class StepsController < ApplicationController
    include KnowledgeCamp

    def index
      display Step.where(:tutorial_id => params[:tutorial_id])
    end

    def show
      display Step.find(params[:id])
    end
  end
end
