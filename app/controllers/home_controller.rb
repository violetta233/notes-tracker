class HomeController < ApplicationController
  def index
    if current_user
      @notes = Note.available_to(current_user).order(created_at: :desc).limit(4)
      @habits = current_user.habits.order(created_at: :desc).limit(4)
    end
  end
end
