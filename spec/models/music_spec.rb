require 'rails_helper'

RSpec.describe Music, type: :model do
  context 'validation' do
    subject { build(:music) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:composer) }
    it { is_expected.to validate_presence_of(:style) }
    it { is_expected.to validate_presence_of(:arranger) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to define_enum_for(:status) }
  end

  context 'associations' do
    let(:user) { create(:user)}
    let(:music) { create(:music, user: user) }
    let(:practice_session1) { create(:practice_session) }
    let(:practice_session2) { create(:practice_session) }
    let(:rehearsed_musics) do
      create(:rehearsed_music,
             practice_session: practice_session1,
             music: music)
      create(:rehearsed_music,
             practice_session: practice_session2,
             music: music)
    end

    before { rehearsed_musics }

    it 'has many rehearsed_music' do
      expect(music.rehearsed_musics.count).to eq 2
      expect(music.rehearsed_musics.first.id).to eq RehearsedMusic.first.id
      expect(music.rehearsed_musics.last.id).to eq RehearsedMusic.second.id
    end

    it 'has many practice_session through rehearsed_musics' do
      expect(music.practice_sessions.count).to eq 2
      expect(music.practice_sessions.first.id).to eq practice_session1.id
      expect(music.practice_sessions.last.id).to eq practice_session2.id
    end

    it 'belongs to a user' do
      expect(music.user).to eq user
    end
  end
end
