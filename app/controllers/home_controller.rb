class HomeController < ApplicationController
  def index
    if current_user
      @notes = current_user.notes.order(created_at: :desc).limit(4)
      @habits = current_user.habits.order(created_at: :desc).limit(4)
    end
  end
end
