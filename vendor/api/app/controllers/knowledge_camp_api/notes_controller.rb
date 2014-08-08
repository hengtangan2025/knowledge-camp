module KnowledgeCampApi
  class NotesController < ApplicationController
    include KnowledgeNetPlanStore
    include KnowledgeCamp

    def index
      case query_key
      when :tutorial_id
        step_ids = Tutorial.find(params[:tutorial_id]).step_ids

        display notes.where(:step_id.in => step_ids)
      when :step_id
        display notes.where(:step_id => params[:step_id])
      end
    end

    def show
      display notes.find(params[:id])
    end

    def create
      display notes.create!(note_params), 201
    end

    private

    def notes
      current_user.notes
    end

    def note_params
      params.require(:note).permit(:step_id, :content, :kind)
    end

    def query_key
      first_key [
        :tutorial_id,
        :step_id
      ]
    end
  end
end
