class NotesController < ApplicationController
  layout "new_version_base"

  def ware
    ware = KcCourses::Ware.find params[:ware_id]

    notes = ware.notes.where(:creator_id => current_user.id).page(params[:page]).per(15)

    data = notes.map do |note|
      DataFormer.new(note).data
    end

    result = {
      notes: data,
      paginate: DataFormer.paginate_data(notes),
      create_url: notes_path
    }

    render json: result
  end

  def create
    note = NoteMod::Note.new note_params
    note.creator = current_user
    _process_targetable note

    save_model(note) do |_note|
      DataFormer.new(_note).data
    end
  end

  private
  def _process_targetable(note)
    if params[:ware_id].present?
      note.targetable = KcCourses::Ware.find params[:ware_id]
    end
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
