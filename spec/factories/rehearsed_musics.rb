FactoryBot.define do
  factory :rehearsed_music do
    practice_session { association :practice_session || PracticeSession.last }
    music { association :music || Music.last }
  end
end
