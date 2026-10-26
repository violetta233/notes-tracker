class NotesController < ApplicationController
  def new
    @note = Note.new
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      redirect_to root_path, notice: "Заметка создана!"
    else
      # Если не сохранилось, показываем форму заново с ошибками
      render :new, status: :unprocessable_entity
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :tag, :body)
  end
end
