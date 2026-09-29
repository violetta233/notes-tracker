require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(
      name: "Violetta",
      email: "violetta@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end

  test "password is stored as a digest" do
    user = User.create!(
      name: "Violetta",
      email: "password@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not_equal "password123", user.password_digest
    assert user.authenticate("password123")
  end

  test "email must be unique" do
    User.create!(
      name: "First User",
      email: "same@example.com",
      password: "password123"
    )

    duplicate_user = User.new(
      name: "Second User",
      email: "same@example.com",
      password: "password456"
    )

    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end
end
