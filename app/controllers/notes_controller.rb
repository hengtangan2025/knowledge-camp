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
    note = NoteMod::Note.new note_create_params
    note.creator = current_user

    save_model(note) do |_note|
      DataFormer.new(_note).data
    end
  end

  private
  def note_create_params
    hash = params.require(:note).permit(:title, :content, :ware_id)
    ware_id = hash.delete :ware_id
    hash[:targetable] = KcCourses::Ware.find(ware_id) if ware_id.present?
    hash
  end
end
