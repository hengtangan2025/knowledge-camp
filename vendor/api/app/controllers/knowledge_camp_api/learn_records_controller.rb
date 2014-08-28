module KnowledgeCampApi
  class LearnRecordsController < ApplicationController
    def create
      display current_user.learn_records.create!(record_params), 201
    end

    def index
      criteria = current_user.learn_records

      display criteria.find_by(:tutorial_id => params.require(:tutorial_id))
    end

    private

    def record_params
      params.require(:learn_record).permit(:step_id)
    end
  end
end
