require "test_helper"

class UserFlowsTest < ActionDispatch::IntegrationTest
  def setup
    # Создаем пользователя для тестов входа
    @user = User.create!(
      name: "Тестовый Пользователь",
      email: "test@example.com",
      password: "password123"
    )
  end

  # ==========================================
  # ПОЗИТИВНЫЕ СЦЕНАРИИ (Happy Path)
  # ==========================================

  test "пользователь может зарегистрироваться" do
    # Проверяем, что количество юзеров увеличится на 1
    assert_difference("User.count", 1) do
      post register_path, params: {
        user: {
          name: "Новый Пользователь",
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    # Проверяем, что нас перекинуло на главную
    assert_redirected_to root_path

    # Идем по редиректу и проверяем приветствие
    follow_redirect!
    assert_select "h1", text: /Добро пожаловать, Новый Пользователь/
  end

  test "пользователь может войти и создать заметку" do
    # 1. Входим в систему
    post login_path, params: { email: @user.email, password: "password123" }
    assert_redirected_to root_path

    # 2. Создаем заметку
    assert_difference("Note.count", 1) do
      post notes_path, params: {
        note: { title: "Моя первая заметка", body: "Текст заметки", tag: "Идеи" }
      }
    end

    # 3. Проверяем редирект и наличие заметки на странице
    assert_redirected_to root_path
    follow_redirect!
    assert_select "h3", text: "Моя первая заметка"
  end

  # ==========================================
  # НЕГАТИВНЫЕ СЦЕНАРИИ (Обработка ошибок)
  # ==========================================

  test "пользователь НЕ может войти с неверным паролем" do
    post login_path, params: { email: @user.email, password: "wrong_password" }

    # Проверяем, что сервер вернул статус 422 (ошибка валидации)
    assert_response :unprocessable_entity
    # Проверяем, что на странице есть текст ошибки
    assert_match "Неверный email или пароль", response.body
  end

  test "пользователь НЕ может создать пустую заметку" do
    # Сначала логинимся
    post login_path, params: { email: @user.email, password: "password123" }

    # Пытаемся отправить пустую форму
    assert_no_difference("Note.count") do
      post notes_path, params: {
        note: { title: "", body: "", tag: "" }
      }
    end

    # Сервер должен вернуть статус ошибки и показать форму заново с ошибками
    assert_response :unprocessable_entity
    assert_match "Title can&#39;t be blank", response.body # Проверяем текст ошибки
  end
end
