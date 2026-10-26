class NotesController < ApplicationController
  def new
    @note = Note.new
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      redirect_to root_path, notice: "Заметка создана!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @note = current_user.notes.find(params[:id])
    @note.destroy
    redirect_to root_path, notice: "Заметка удалена!"
  end

  private

  def note_params
    params.require(:note).permit(:title, :tag, :body)
  end
end
