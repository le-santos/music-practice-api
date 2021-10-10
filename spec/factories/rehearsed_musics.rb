FactoryBot.define do
  factory :rehearsed_music do
    practice_session { association(:practice_session) }
    music { association(:music) }
  end
end
