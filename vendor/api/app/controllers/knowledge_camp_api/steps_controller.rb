module KnowledgeCampApi
  class StepsController < ApplicationController
    def index
      display KnowledgeCamp::Step.where(:stepped_id   => params.require(:tutorial_id),
                                        :stepped_type => KnowledgeNetPlanStore::Tutorial.name)
    end

    def show
      display KnowledgeCamp::Step.find(params[:id])
    end
  end
end
