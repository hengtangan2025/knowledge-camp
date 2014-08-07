module KnowledgeCampApi
  class NotesController < ApplicationController
    include KnowledgeCamp

    def index
      display Note.where(:tutorial_id => params[:tutorial_id])
    end

    def show
      display Note.find(params[:id])
    end

    def create
      display Note.create(note_params), 201
    end

    private

    def note_params
      params.require(:note).permit(:step_id, :content, :kind)
    end
    private

    def cond
      return {:tutorial_id => params[:tutorial_id]} if params[:tutorial_id]
      {:step_id => params[:step_id]} if params[:step_id]
    end
  end
end
