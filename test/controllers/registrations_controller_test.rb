require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get registration page" do
    get register_path

    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post register_path, params: {
        user: {
          name: "Test User",
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
  end
end