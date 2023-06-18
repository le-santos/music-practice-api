FactoryBot.define do
  factory :music do
    title { 'Sonata 1' }
    composer { 'Paul Quarter-notes' }
    style { 'Modern' }
    arranger { 'Joana Rest' }
    category { 0 }
    status { 0 }
    user { association(:user) }
  end
end
