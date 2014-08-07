module KnowledgeCampApi
  class LearnRecordsController < ApplicationController
    include KnowledgeNetPlanStore

    def create
      display LearnRecord.create(record_params), 201
    end

    private

    def record_params
      params.require(:learn_record).permit(:tutorial_id)
    end
  end
end
