require 'rails_helper'
require 'pundit/rspec'

RSpec.describe PracticeSessionPolicy, type: :policy do
  subject(:policy) { described_class }

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
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
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
