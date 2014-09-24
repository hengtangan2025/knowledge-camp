module KnowledgeCampApi
  class NotesController < ApplicationController
    def show
      display note
    end

    def update
      note.update_attributes(note_params)

      display note
    end

    def create
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
