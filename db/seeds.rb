ActiveRecord::Base.transaction do
  # Create test user
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

  # musics_data.each { |music| Music.create!(music) }

  # Large sample for sidekiq tests
  puts '==================='
  puts 'Creating new Musics'
  puts ''

  10_000.times do |index|
    date = index.even? ? DateTime.now - 3.days : DateTime.now - 60.days

    music = {
      title: "Title #{index}",
      composer: "Composer #{index}",
      style: "Style #{index}",
      arranger: "Arranger #{index}",
      category: 1,
      last_played: date,
      user_id: sample_user.id
    }

    Music.create!(music)
  end

  puts '==================='
  puts 'Created 10.000 musics'
  puts ''


  # PracticeSessions with varied status
  session1 = PracticeSession.create!(
    goals: 'Estudar parte A com metrônomo',
    notes: 'Pratiquei com metrônomo de 60 a 90 bpm',
    status: :completed,
    user_id: sample_user.id
  )

  session2 = PracticeSession.create!(
    goals: 'Praticar fraseado do final',
    notes: '',
    status: :planned,
    user_id: sample_user.id
  )

  session3 = PracticeSession.create!(
    goals: 'Leitura da primeira página',
    notes: '',
    status: :pending,
    user_id: sample_user.id
  )

  # RehearsedMusic
  RehearsedMusic.create!(practice_session_id: session1.id, music_id: Music.first.id)
  RehearsedMusic.create!(practice_session_id: session2.id, music_id: Music.second.id)
  RehearsedMusic.create!(practice_session_id: session3.id, music_id: Music.last.id)
end
