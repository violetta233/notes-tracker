class HabitsController < ApplicationController
  def new
  end

  def create
    redirect_to root_path, notice: "Привычка пока не сохраняется (в разработке)"
  end
end