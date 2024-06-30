require 'rails_helper'
require 'pundit/rspec'

RSpec.describe MusicPolicy, type: :policy do
  subject(:policy) { described_class }

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    it 'denies access if User is does not own Music' do
      other_user = create(:user)
      user = create(:user)
      music = build(:music, user: user)

      expect(policy).not_to permit(other_user, music)
    end

    it 'permits access if User owns Music' do
      user = create(:user)
      music = build(:music, user: user)

      expect(policy).to permit(user, music)
    end
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :edit?, :update? do
    it 'denies access if User is does not own Music' do
      other_user = create(:user)
      user = create(:user)
      music = build(:music, user: user)

      expect(policy).not_to permit(other_user, music)
    end

    it 'permits access if User owns Music' do
      user = create(:user)
      music = build(:music, user: user)

      expect(policy).to permit(user, music)
    end
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
