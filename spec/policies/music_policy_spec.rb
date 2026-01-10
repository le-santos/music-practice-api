require 'rails_helper'
require 'pundit/rspec'

RSpec.describe MusicPolicy, type: :policy do
  subject(:policy) { described_class }

  permissions '.scope' do
    it 'returns only musics owned by the user' do
      user = create(:user)
      other_user = create(:user)
      user_musics = create_list(:music, 2, user: user)
      create_list(:music, 2, user: other_user)

      scope = Pundit.policy_scope(user, Music)
      expect(scope).to contain_exactly(*user_musics)
    end
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
    it 'permits user to create music' do
      user = create(:user)
      music = build(:music, user: user)

      expect(policy).to permit(user, music)
    end
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
    it 'denies access if User does not own Music' do
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
end
