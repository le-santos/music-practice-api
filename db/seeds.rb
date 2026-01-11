ActiveRecord::Base.transaction do
  # Create test users
  puts '========= Creating Users ==========='
  User.create!(username: 'Fulano', email: 'email1@email', password: '123456qwerty')
  User.create!(username: 'Beltrano', email: 'email2@email', password: '123456123456')

  # Params for creating Music
  musics_params = [
    {
      title: 'Suite 1 para violoncelo BWV 1007',
      composer: 'J. S. Bach',
      style: 'Barroco',
      arranger: '',
      category: 0,
      status: 1
    },
    {
      title: 'Capricho Àrabe',
      composer: 'Francisco Tárrega',
      style: 'Romântico',
      arranger: '',
      category: 0,
      status: 1
    },
    {
      title: 'Fantasia 7',
      composer: 'John Dowland',
      style: 'Renascimento',
      arranger: '',
      category: 0,
      status: 1
    },
    {
      title: 'La vida breve',
      composer: 'Manuel de Falla',
      style: 'Moderno',
      arranger: 'Sergio Abreu',
      category: 1
    }
  ]

  create_music_and_sessions = lambda do |musics_params, user_id|
    musics_params.each do |music|
      new_music = Music.create!(user_id: user_id, **music)

      5.times do
        PracticeSession.create!(
          goals: Faker::Lorem.words(number: rand(4..6)).join(' '),
          music: new_music,
          notes: Faker::Lorem.words(number: rand(4..6)).join(' '),
          status: %i[completed pending planned].sample,
          user_id: user_id
        )
      end
    end
  end

  puts '========= Creating Music and PracticeSessions ==========='

  User.pluck(:id).each { |user_id| create_music_and_sessions.call(musics_params, user_id) }

  puts '========= Seed Complete! ==========='
end
