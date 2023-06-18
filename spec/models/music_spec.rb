require 'rails_helper'

RSpec.describe Music, type: :model do
  context 'validation' do
    subject { build(:music) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:composer) }
    it { is_expected.to validate_presence_of(:style) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to define_enum_for(:status) }
  end

  context 'associations' do
    let(:user) { create(:user) }
    let(:music) { create(:music, user:) }
    let(:create_practice_sessions) do
      2.times { create(:practice_session, music:) }
    end

    it 'has many practice_sessions' do
      create_practice_sessions

      expect(music.practice_sessions.count).to eq 2
    end

    it 'belongs to a user' do
      expect(music.user).to eq user
    end
  end

  context '#last_played_at' do
    let(:music) { create(:music) }
    let(:older_practice_session) { create(:practice_session, created_at: 3.days.ago, music:) }
    let(:newer_practice_session) { create(:practice_session, created_at: 1.days.ago, music:) }

    it 'returns last_played date based on the recent PracticeSession' do
      older_practice_session
      newer_practice_session

      expect(music.last_played_at).to eq(newer_practice_session.created_at)
    end

    context 'when music does not have any practice_session' do
      it 'returns nil' do
        expect(music.last_played_at).to be_nil
      end
    end
  end
end
