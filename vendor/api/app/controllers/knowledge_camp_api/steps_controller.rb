module KnowledgeCampApi
  class StepsController < ApplicationController
    def index
      options = {
        :stepped_id   => params[:tutorial_id],
        :stepped_type => KnowledgeNetPlanStore::Tutorial.name
      }

      display KnowledgeCamp::Step.where(options).map {|step| add_learned(step)}
    end

    def show
      display add_learned(KnowledgeCamp::Step.find(params[:id]))
    end

    private

    def add_learned(step)
      is_learned = step.learn_records.where(:user_id => current_user.id).size > 0

      step.attrs.merge(:is_learned => is_learned)
    end
  end
end
