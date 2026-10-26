class HabitsController < ApplicationController
  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      redirect_to root_path, notice: "Привычка создана!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def habit_params
    params.require(:habit).permit(:name, :frequency, :description)
  end
end
