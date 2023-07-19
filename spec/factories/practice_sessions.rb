FactoryBot.define do
  factory :practice_session do
    goals { 'MyString' }
    notes { 'MyString' }
    attachments { 'MyString' }
    user { association(:user) }
    music { association(:music) }
  end
end
