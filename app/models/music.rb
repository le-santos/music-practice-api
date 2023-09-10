class Music < ApplicationRecord
  validates :title, :composer, :style,
            :category, :status, presence: true

  belongs_to :user
  has_many :practice_sessions, dependent: :destroy

  enum status: { archived: 0, learning: 1, reviewing: 2, performing: 9 }

  scope :forgotten, lambda { |user, months_period = 6|
    recently_played_music =
      joins(:practice_sessions)
      .where(user: user)
      .where(practice_sessions: { status: :completed })
      .where('practice_sessions.created_at > ?', months_period.months.ago)

    where.not(id: recently_played_music)
  }

  def last_played_at
    practice_sessions.order(created_at: :desc).first&.created_at
  end
end
