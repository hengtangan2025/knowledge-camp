module KnowledgeCampApi
  class NotesController < ApplicationController
    def index
      display notes
    end

    def show
      display note
    end

    def update
      @note = note
      @note.update_attributes(note_params)
      @note.save

      display @note
    end

    def create
      selection = KnowledgeCamp::Step.find(note_params[:step_id]).selection_of(current_user)
      return display(:nothing, 422) if notes.where(:selection_id => selection.id).first
      display notes.create!(note_params), 201
    end

    def destroy
      note.destroy
      display :nothing
    end

    private

    def note
      notes.find(params[:id])
    end

    def notes
      current_user.notes
    end

    def note_params
      params.require(:note).permit(:step_id, :content)
    end
  end
end
