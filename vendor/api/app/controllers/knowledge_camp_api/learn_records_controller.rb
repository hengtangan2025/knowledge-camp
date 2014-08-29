module KnowledgeCampApi
  class LearnRecordsController < ApplicationController
    def create
      display current_user.learn_records.create!(record_params)
    end

    def index
      criteria = current_user.learn_records

      display criteria.find_by(:step_id => params.require(:step_id))
    end

    private

    def record_params
      params.require(:learn_record).permit(:step_id)
    end
  end
end
