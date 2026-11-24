class NotesController < ApplicationController
  before_action :require_login
  before_action :set_note, only: [ :destroy, :share, :revoke, :edit, :update ]

  def index
    # Показываем свои заметки И те, где мы в соавторах
    @notes = Note.available_to(current_user).order(created_at: :desc)
  end

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

  def edit
  end

  def update
    if @note.update(note_params)
      redirect_to notes_path, notice: "Заметка обновлена!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

    def destroy
    if @note.user == current_user
      @note.destroy
      redirect_back fallback_location: root_path, notice: "Заметка удалена!"
    else
      redirect_back fallback_location: root_path, alert: "Удалять заметку может только автор."
    end
  end

  def share
    @note.share!
    redirect_back fallback_location: root_path, notice: "Ссылка создана!"
  end

  def revoke
    @note.revoke_share!
    redirect_back fallback_location: root_path, notice: "Ссылка отозвана!"
  end

  private

  def set_note
    @note = Note.available_to(current_user).find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :tag, :body, :shared_editing)
  end
end
