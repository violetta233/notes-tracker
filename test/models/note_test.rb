require "test_helper"

class NoteTest < ActiveSupport::TestCase
  def setup
    @user = users(:violetta)
    @note = Note.new(
      title: "Идея",
      body: "Текст заметки",
      tag: "Проект",
      user: @user
    )
  end

  test "valid note saves" do
    assert @note.save
  end

  test "invalid without title" do
    @note.title = nil
    assert_not @note.save
  end

  test "invalid without body" do
    @note.body = nil
    assert_not @note.save
  end

  test "invalid without user" do
    @note.user = nil
    assert_not @note.save
  end

  test "invalid with too long title" do
    @note.title = "a" * 101
    assert_not @note.save
  end

  test "invalid with wrong tag" do
    @note.tag = "Другое"
    assert_not @note.save
  end

  test "valid without tag" do
    @note.tag = nil
    assert @note.save
  end

  test "user notes destroyed with user" do
  @note.save
  assert_difference("Note.count", -3) do
    @user.destroy
  end
end
end