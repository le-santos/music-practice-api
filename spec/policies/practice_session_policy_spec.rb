require 'rails_helper'
require 'pundit/rspec'

RSpec.describe PracticeSessionPolicy, type: :policy do
  subject(:policy) { described_class }

  permissions '.scope' do
    it 'returns only practice sessions owned by the user' do
      user = create(:user)
      other_user = create(:user)
      user_sessions = create_list(:practice_session, 2, user: user)
      other_user_sessions = create_list(:practice_session, 2, user: other_user)

      scope = Pundit.policy_scope(user, PracticeSession)
      expect(scope).to contain_exactly(*user_sessions)
    end
  end

  permissions :show? do
    it 'denies access if User is does not own PracticeSession' do
      other_user = create(:user)
      user = create(:user)
      practice_session = build(:practice_session, user: user)

      expect(policy).not_to permit(other_user, practice_session)
    end

    it 'permits access if User owns PracticeSession' do
      user = create(:user)
      practice_session = build(:practice_session, user: user)

      expect(policy).to permit(user, practice_session)
    end
  end

  permissions :create? do
    it 'permits user to create practice session' do
      user = create(:user)
      practice_session = build(:practice_session, user: user)

      expect(policy).to permit(user, practice_session)
    end
  end

  permissions :update? do
    it 'denies access if User does not own PracticeSession' do
      other_user = create(:user)
      user = create(:user)
      practice_session = build(:practice_session, user: user)

      expect(policy).not_to permit(other_user, practice_session)
    end

    it 'permits access if User owns PracticeSession' do
      user = create(:user)
      practice_session = build(:practice_session, user: user)

      expect(policy).to permit(user, practice_session)
    end
  end

  permissions :destroy? do
    it 'denies access if User does not own PracticeSession' do
      other_user = create(:user)
      user = create(:user)
      practice_session = build(:practice_session, user: user)

      expect(policy).not_to permit(other_user, practice_session)
    end

    it 'permits access if User owns PracticeSession' do
      user = create(:user)
      practice_session = build(:practice_session, user: user)

      expect(policy).to permit(user, practice_session)
    end
  end
end
