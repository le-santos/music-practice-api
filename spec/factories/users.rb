FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "Fulano_#{n}" }
    sequence(:email) { |n| "person#{n}@email" }
    password { '123456qwerty' }
  end
end
