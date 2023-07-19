require 'rails_helper'

RSpec.describe PracticeSession, type: :model do
  context 'validation' do
    subject { create(:practice_session) }

    it { is_expected.to validate_presence_of(:goals) }
    it { is_expected.to define_enum_for(:status) }
  end

  context 'associations' do
    let(:user) { create(:user) }
    let(:music) { create(:music) }
    let(:practice_session) { create(:practice_session, user: user, music: music) }

    it 'belongs to a music' do
      expect(practice_session.music).to eq music
    end

    it 'belongs to a user' do
      expect(practice_session.user).to eq user
    end
  end
end
