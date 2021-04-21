class Music < ApplicationRecord
  validates :title, :composer, :style, :arranger, :category, presence: true
  has_many :rehearsed_musics, dependent: :destroy
  has_many :practice_sessions, through: :rehearsed_musics
end
