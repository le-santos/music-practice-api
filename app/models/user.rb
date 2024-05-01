class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Remove it?
  # has_secure_password

  # change password digest?
  validates :username, :email, :password_digest, presence: true
  validates :username, :email, uniqueness: true

  has_many :musics, dependent: :destroy
  has_many :practice_sessions, dependent: :destroy
end
