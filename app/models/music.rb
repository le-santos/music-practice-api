class Music < ApplicationRecord
  validates :title, :composer, :style, :arranger,
            :category, :status, presence: true
  has_many :rehearsed_musics, dependent: :destroy
  has_many :practice_sessions, through: :rehearsed_musics

  enum status: { archived: 0, learning: 1, reviewing: 2, performing: 9 }
end
