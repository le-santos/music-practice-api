class PracticeSession < ApplicationRecord
  validates :goals, presence: true
  has_many :rehearsed_musics, dependent: :destroy
  has_many :musics, through: :rehearsed_musics

  enum status: { pending: 0, planned: 1, completed: 9 }
end
