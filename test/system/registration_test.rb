require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
  test "user can register" do
    visit register_path

    fill_in "Имя", with: "Test User"
    fill_in "Email", with: "system@example.com"
    fill_in "Пароль", with: "password123"
    fill_in "Повторите пароль", with: "password123"

    click_on "Зарегистрироваться ♡"

    assert_text "Добро пожаловать, Test User"
  end
end
