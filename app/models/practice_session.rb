class PracticeSession < ApplicationRecord
  validates :goals, presence: true
end
