require 'rails_helper'

RSpec.describe PracticeSession, type: :model do
  context 'validation' do
    subject { create(:practice_session) }

    it { is_expected.to validate_presence_of(:goals) }
  end

  context 'associations' do
    let(:music1) { create(:music) }
    let(:music2) { create(:music) }
    let(:practice_session) { create(:practice_session) }
    let(:rehearsed_musics) do
      create(:rehearsed_music,
             practice_session: practice_session,
             music: music1)
      create(:rehearsed_music,
             practice_session: practice_session,
             music: music2)
    end

    before { rehearsed_musics }

    it 'has many rehearsed_music' do
      expect(practice_session.rehearsed_musics.count).to eq 2
      expect(practice_session.rehearsed_musics.first.id).to eq music1.id
    end

    it 'has many musics through rehearsed_musics' do
      expect(practice_session.musics.count).to eq 2
      expect(practice_session.musics.first.id).to eq music1.id
      expect(practice_session.musics.last.id).to eq music2.id
    end
  end
end
