class User < ApplicationRecord
  has_secure_password
  has_many :notes, dependent: :destroy
  has_many :habits, dependent: :destroy

  has_many :note_shares, dependent: :destroy
  has_many :shared_notes, through: :note_shares, source: :note

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
