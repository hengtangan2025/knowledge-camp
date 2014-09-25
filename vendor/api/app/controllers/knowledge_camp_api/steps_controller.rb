module KnowledgeCampApi
  class StepsController < ApplicationController
    def index
      options = {
        :stepped_id   => params[:tutorial_id],
        :stepped_type => KnowledgeNetPlanStore::Tutorial.name
      }

      display KnowledgeCamp::Step.where(options).map {|step| add_addons(step)}
    end

    def show
      display add_addons(step)
    end

    def update
      @step = step
      @selection = @step.selection_of(current_user)
      @selection.hard = step_params[:is_hard]
      @selection.save

      display add_addons(@step)
    end

    private

    def step_params
      params.require(:step).permit(:is_hard)
    end

    def step
      KnowledgeCamp::Step.find(params[:id])
    end

    def add_addons(step)
      @step = step

      is_learned = @step.learn_records.where(:user_id => current_user.id).size > 0
      question   = @step.question_of(current_user)
      note       = @step.note_of(current_user)

      attrs = {
        :is_learned  => is_learned,
        :question_id => question && question.id.to_s,
        :note_id     => note && note.id.to_s,
        :is_hard     => !!@step.selection_of(current_user).hard
      }

      @step.attrs.merge(attrs)
    end
  end
end
