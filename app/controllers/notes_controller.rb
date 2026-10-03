class NotesController < ApplicationController
  def new
  end

  def create
    redirect_to root_path, notice: "Заметка пока не сохраняется (в разработке)"
  end
end