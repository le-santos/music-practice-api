FactoryBot.define do
  factory :music do
    title { 'Sonata 1' }
    composer { 'Paul Quarter-notes' }
    style { 'Modern' }
    arranger { 'Joana Rest' }
    category { 0 }
    last_played { '2021-04-19 19:07:08' }
    status { 0 }
  end
end
