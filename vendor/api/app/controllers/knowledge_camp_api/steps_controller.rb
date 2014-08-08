module KnowledgeCampApi
  class StepsController < ApplicationController
    include KnowledgeNetPlanStore
    include KnowledgeCamp

    def index
      display Step.where(:stepped_id   => params.require(:tutorial_id),
                         :stepped_type => Tutorial.name)
    end

    def show
      display Step.find(params[:id])
    end
  end
end
