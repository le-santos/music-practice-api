class Music < ApplicationRecord
  validates :title, :composer, :style,
            :category, :status, presence: true

  belongs_to :user
  has_many :practice_sessions, dependent: :destroy

  enum status: { archived: 0, learning: 1, reviewing: 2, performing: 9 }

  def last_played_at
    practice_sessions.order(created_at: :desc).first&.created_at
  end
end
