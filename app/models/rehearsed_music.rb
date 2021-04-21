class RehearsedMusic < ApplicationRecord
  belongs_to :practice_session
  belongs_to :music
end
