class Note < ApplicationRecord
  belongs_to :user

  belongs_to :source_note, class_name: "Note", optional: true
  has_many :copies, class_name: "Note", foreign_key: "source_note_id", dependent: :nullify

  # Автогенерация токена при создании
  before_create :generate_share_token

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true
  validates :tag, inclusion: { in: %w[Личное Проект Идеи], allow_blank: true }

  scope :recent, -> { order(created_at: :desc) }

  # ФИЧА SHARE
  def shared?
    share_token.present?
  end

  def share!
    update!(share_token: SecureRandom.urlsafe_base64(12)) unless shared?
  end

  def revoke_share!
    update!(share_token: nil)
  end

  def can_be_edited_by?(user)
    user == self.user || shared_editing?
  end

  # Копирование чужой заметки к себе
  def copy_to!(new_user, overrides = {})
    new_user.notes.create!(
      title: "#{title} (копия)",
      body: body,
      tag: tag,
      source_note_id: id
    ).tap do |copy|
      copy.update(overrides.to_h) if overrides.present?
    end
  end

  private

  def generate_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(12)
  end
end
