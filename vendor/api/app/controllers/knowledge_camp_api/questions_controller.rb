module KnowledgeCampApi
  class QuestionsController < ApplicationController
    def index
      display questions
    end

    def show
      display question
    end

    def update
      @question = question
      @question.update_attributes(question_params)
      @question.save

      display @question
    end

    def create
      selection = KnowledgeCamp::Step.find(note_params[:step_id]).selection_of(current_user)
      return display(:nothing, 422) if questions.where(:selection_id => selection.id).first
      display questions.create!(question_params), 201
    end

    def destroy
      question.destroy
      display :nothing
    end

    private

    def question
      questions.find(params[:id])
    end

    def questions
      current_user.questions
    end

    def question_params
      params.require(:question).permit(:step_id, :content)
    end
  end
end
