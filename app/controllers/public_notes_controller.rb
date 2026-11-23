class PublicNotesController < ApplicationController
  skip_before_action :require_login, only: [ :show, :update ], raise: false
  before_action :set_note, only: [ :show, :update ]

  def show
    # Если это чужая заметка, передаем имя автора для приписки
    @shared_with_name = @note.user.name if current_user && @note.user != current_user
  end

  def update
    if current_user
      if @note.can_be_edited_by?(current_user) && params[:commit] == "Обновить оригинал"
        # Обновляем оригинал (если автор или разрешено)
        if @note.update(note_params)
          redirect_to public_note_path(@note.share_token), notice: "Оригинал заметки обновлен!"
        else
          render :show, status: :unprocessable_entity
        end
      else
        # Создаем копию для текущего пользователя
        @note.copy_to!(current_user, note_params)
        redirect_to notes_path, notice: "Заметка сохранена в вашем списке!"
      end
    else
      redirect_to login_path, alert: "Войдите, чтобы сохранить заметку"
    end
  end

  private

  def set_note
    @note = Note.find_by!(share_token: params[:token])
  rescue ActiveRecord::RecordNotFound
    render plain: "Заметка не найдена или ссылка отозвана", status: :not_found
  end

  def note_params
    params.require(:note).permit(:title, :body, :tag)
  end
end
