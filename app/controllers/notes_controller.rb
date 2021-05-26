class NotesController < ApplicationController
  before_action :must_be_logged_in
  before_action :must_be_author_or_admin, only: [:destroy]

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id

    if @note.save
      redirect_to track_url(@note.track_id)
    else
      flash.now[:errors] = @note.errors.full_messages
      redirect_to track_url(@note.track_id)
    end
  end

  def destroy
    @note = Note.find_by(id: params[:id])
    @note.destroy
    flash[:notice] = ["The note has been deleted"]
    redirect_to track_url(@note.track_id)
  end

  private

  def note_params
    params.require(:note).permit(:track_id, :content)
  end

  def must_be_author_or_admin
    return if current_user.id == params[:id].to_i
    return if current_user.admin
    render text: "You cannot delete this note", status: :unprocessable_entity
  end
end