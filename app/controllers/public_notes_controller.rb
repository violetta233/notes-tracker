class PublicNotesController < ApplicationController
  skip_before_action :require_login, only: [ :show, :update ], raise: false
  before_action :set_note, only: [ :show, :update ]

  def show
    @shared_with_name = @note.user.name if current_user && @note.user != current_user
  end

  def update
    if current_user
      # Если нажали "Сохранить копию" — добавляем в соавторы и шлем на главную
      if params[:commit] == "Сохранить копию"
        @note.add_collaborator(current_user)
        @note.update(note_params)
        redirect_to root_path, notice: "Заметка добавлена в ваш список (совместный доступ)!"

      # Если нажали "Обновить оригинал" — обновляем и остаемся на странице
      elsif @note.can_be_edited_by?(current_user)
        if @note.update(note_params)
          redirect_to public_note_path(@note.share_token), notice: "Заметка обновлена!"
        else
          render :show, status: :unprocessable_entity
        end
      else
        @note.add_collaborator(current_user)
        @note.update(note_params)
        redirect_to root_path, notice: "Заметка добавлена в ваш список!"
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
