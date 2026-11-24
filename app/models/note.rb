class Note < ApplicationRecord
  belongs_to :user
  belongs_to :source_note, class_name: "Note", optional: true
  has_many :copies, class_name: "Note", foreign_key: "source_note_id", dependent: :nullify

  before_create :generate_share_token

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true
  validates :tag, inclusion: { in: %w[Личное Проект Идеи], allow_blank: true }

  scope :recent, -> { order(created_at: :desc) }

  # Заметки, доступные пользователю (свои + те, где он в списке соавторов)
  scope :available_to, ->(user) {
    where("user_id = :id OR collaborator_ids LIKE :pattern", id: user.id, pattern: "%#{user.id}%")
  }

  def shared?
    share_token.present?
  end

  def share!
    update!(share_token: SecureRandom.urlsafe_base64(12)) unless shared?
  end

  def revoke_share!
    update!(share_token: nil)
  end

  # Добавляем пользователя в соавторы
  def add_collaborator(user)
    current_ids = collaborator_ids.present? ? collaborator_ids.split(",").map(&:to_i) : []
    unless current_ids.include?(user.id)
      current_ids << user.id
      update!(collaborator_ids: current_ids.join(","))
    end
  end

  # Проверка прав на редактирование
  def can_be_edited_by?(user)
    return true if user == self.user
    return true if shared_editing?

    current_ids = collaborator_ids.present? ? collaborator_ids.split(",").map(&:to_i) : []
    current_ids.include?(user.id)
  end

  private

  def generate_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(12)
  end
end
