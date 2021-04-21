require 'rails_helper'

RSpec.describe Music, type: :model do
  context 'validation' do
    # add tests
  end

  context 'associations' do
    it 'has many rehearsed_music' do
      music = FactoryBot.create(:music)
      practice_session1 = FactoryBot.create(:practice_session)
      practice_session2 = FactoryBot.create(:practice_session)

      RehearsedMusic.create!(practice_session: practice_session1, music: music)
      RehearsedMusic.create!(practice_session: practice_session2, music: music)

      expect(music.rehearsed_musics.count).to eq 2
      expect(music.rehearsed_musics.first.id).to eq practice_session1.id
      expect(music.rehearsed_musics.last.id).to eq practice_session2.id
    end

    it 'has many practice_session through rehearsed_musics' do
      music = FactoryBot.create(:music)
      practice_session1 = FactoryBot.create(:practice_session)
      practice_session2 = FactoryBot.create(:practice_session)

      RehearsedMusic.create!(practice_session: practice_session1, music: music)
      RehearsedMusic.create!(practice_session: practice_session2, music: music)

      expect(music.practice_sessions.count).to eq 2
      expect(music.practice_sessions.first.id).to eq practice_session1.id
      expect(music.practice_sessions.last.id).to eq practice_session2.id
    end
  end
end
