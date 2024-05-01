require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    subject { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:musics) }
    it { is_expected.to have_many(:practice_sessions) }
  end
end
