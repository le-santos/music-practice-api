FactoryBot.define do
  factory :practice_session do
    goals { 'MyString' }
    notes { 'MyString' }
    attachments { 'MyString' }
    user { association(:user) }
  end
end
