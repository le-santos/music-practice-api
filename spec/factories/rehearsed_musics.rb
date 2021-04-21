FactoryBot.define do
  factory :rehearsed_music do
    practice_session { PracticeSession.last || association(:practice_session) }
    music { Music.last || association(:music) }
  end
end
