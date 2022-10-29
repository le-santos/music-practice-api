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
end
