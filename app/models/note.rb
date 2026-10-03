class Note < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true
  validates :tag, inclusion: { in: %w[Личное Проект Идеи], allow_blank: true }

  scope :recent, -> { order(created_at: :desc) }
end
