class PracticeSession < ApplicationRecord
  validates :goals, presence: true

  belongs_to :user
  belongs_to :music

  enum status: { pending: 0, planned: 1, completed: 9 }
end
