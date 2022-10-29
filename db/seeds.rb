ActiveRecord::Base.transaction do
  # Create test user
  puts '========= Creating User ==========='
  User.create!(username: 'Fulano', email: 'email@email', password: '123456')
  sample_user ||= User.last

  # Music list for user
  musics_data = [
    {
      title: 'Suite 1 para violoncelo BWV 1007',
      composer: 'J. S. Bach',
      style: 'Barroco',
      arranger: '',
      category: 0,
      status: 1,
      last_played: Time.zone.today,
      user_id: sample_user.id
    },
    {
      title: 'Capricho Àrabe',
      composer: 'Francisco Tárrega',
      style: 'Romântico',
      arranger: '',
      category: 0,
      status: 1,
      last_played: Time.zone.today - 1.month,
      user_id: sample_user.id
    },
    {
      title: 'Fantasia 7',
      composer: 'John Dowland',
      style: 'Renascimento',
      arranger: '',
      category: 0,
      status: 1,
      last_played: '',
      user_id: sample_user.id
    },
    {
      title: 'La vida breve',
      composer: 'Manuel de Falla',
      style: 'Moderno',
      arranger: 'Sergio Abreu',
      category: 1,
      last_played: '',
      user_id: sample_user.id
    }
  ]

  puts '========= Creating User ==========='
  musics_data.each do |music|
    new_music = Music.create!(music)

    3.times do
      PracticeSession.create!(
        goals: Faker::Lorem.words(number: rand(4..6)).join(' '),
        music: new_music,
        notes: Faker::Lorem.words(number: rand(4..6)).join(' '),
        status: %i[completed pending planned].sample,
        user_id: sample_user.id
      )
    end
  end

  puts '========= Seed Complete! ==========='
end
