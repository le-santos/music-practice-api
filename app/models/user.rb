class User < ApplicationRecord
  has_secure_password

  validates :username, :email, :password_digest, presence: true
  validates :username, :email, uniqueness: true

  has_many :musics, dependent: :destroy
  has_many :practice_sessions, dependent: :destroy
end
