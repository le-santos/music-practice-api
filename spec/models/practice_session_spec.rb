require 'rails_helper'

RSpec.describe PracticeSession, type: :model do
  context 'validation' do
    # add tests
  end

  context 'associations' do
    it 'has many rehearsed_music' do
      practice_session = FactoryBot.create(:practice_session)
      music1 = FactoryBot.create(:music)
      music2 = FactoryBot.create(:music)
      RehearsedMusic.create!(practice_session: practice_session, music: music1)
      RehearsedMusic.create!(practice_session: practice_session, music: music2)

      expect(practice_session.rehearsed_musics.count).to eq 2
      expect(practice_session.rehearsed_musics.first.id).to eq music1.id
      expect(practice_session.rehearsed_musics.last.id).to eq music2.id
    end

    it 'has many musics through rehearsed_musics' do
      practice_session = FactoryBot.create(:practice_session)
      music1 = FactoryBot.create(:music)
      music2 = FactoryBot.create(:music)
      RehearsedMusic.create!(practice_session: practice_session, music: music1)
      RehearsedMusic.create!(practice_session: practice_session, music: music2)

      expect(practice_session.musics.count).to eq 2
      expect(practice_session.musics.first.id).to eq music1.id
      expect(practice_session.musics.last.id).to eq music2.id
    end
  end
end
