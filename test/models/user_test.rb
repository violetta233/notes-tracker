require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Violetta",
      email: "test@example.com",
      password: "123456",
      password_confirmation: "123456"
    )
  end

  test "valid user saves" do
    assert @user.save
  end

  test "invalid without name" do
    @user.name = nil
    assert_not @user.save
    assert_includes @user.errors[:name], "can't be blank"
  end

  test "invalid without email" do
    @user.email = nil
    assert_not @user.save
  end

  test "invalid with duplicate email" do
  @user.save
  duplicate = User.new(
    name: "Another",
    email: @user.email,
    password: "123456"
  )
  assert_not duplicate.save
  end

  test "invalid with short password" do
    @user.password = "123"
    @user.password_confirmation = "123"
    assert_not @user.save
  end

  test "authenticates with correct password" do
    @user.save
    assert @user.authenticate("123456")
  end

  test "does not authenticate with wrong password" do
    @user.save
    assert_not @user.authenticate("wrong")
  end

  test "responds to notes" do
    assert_respond_to @user, :notes
  end
end
