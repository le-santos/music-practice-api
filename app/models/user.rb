class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Obs: some validations are already given by devise's validatable module
  # https://github.com/heartcombo/devise/blob/main/lib/devise/models/validatable.rb

  validates :username, :email, presence: true, allow_blank: false
  validates :username, uniqueness: { case_sensitive: true }

  has_many :musics, dependent: :destroy
  has_many :practice_sessions, dependent: :destroy
end
