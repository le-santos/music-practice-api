require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    subject { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:musics) }
    it { is_expected.to have_many(:practice_sessions) }
    it { is_expected.to have_many(:rehearsed_musics).through(:practice_session) }
  end
end
