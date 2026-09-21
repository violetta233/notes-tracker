require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_path

    assert_response :success
  end

  test "should login with valid credentials" do
    user = User.create!(
      name: "Test User",
      email: "login@example.com",
      password: "password123"
    )

    post login_path, params: {
      email: user.email,
      password: "password123"
    }

    assert_redirected_to root_path
  end

  test "should not login with invalid credentials" do
    user = User.create!(
      name: "Test User",
      email: "invalid@example.com",
      password: "password123"
    )

    post login_path, params: {
      email: user.email,
      password: "wrongpassword"
    }

    assert_response :unprocessable_entity
  end

  test "should logout" do
    delete logout_path

    assert_redirected_to root_path
  end
end