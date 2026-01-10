require 'rails_helper'

RSpec.describe PracticeSessionsPresenter do
  let(:user) { build_stubbed(:user) }
  let(:music) { build_stubbed(:music, user: user) }

  let(:pending_session) do
    build_stubbed(:practice_session, user: user, music: music, status: 'pending')
  end
  let(:planned_session) do
    build_stubbed(:practice_session, user: user, music: music, status: 'planned')
  end
  let(:completed_session) do
    build_stubbed(:practice_session, user: user, music: music, status: 'completed')
  end

  describe '#pending_sessions' do
    it 'returns only pending sessions' do
      sessions = [pending_session, planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.pending_sessions).to contain_exactly(pending_session)
    end

    it 'returns empty array when no pending sessions' do
      sessions = [planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.pending_sessions).to be_empty
    end

    it 'memoizes the result' do
      sessions = [pending_session, planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      first_call = presenter.pending_sessions
      second_call = presenter.pending_sessions

      expect(first_call).to equal(second_call)
    end
  end

  describe '#planned_sessions' do
    it 'returns only planned sessions' do
      sessions = [pending_session, planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.planned_sessions).to contain_exactly(planned_session)
    end

    it 'returns empty array when no planned sessions' do
      sessions = [pending_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.planned_sessions).to be_empty
    end

    it 'memoizes the result' do
      sessions = [pending_session, planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      first_call = presenter.planned_sessions
      second_call = presenter.planned_sessions

      expect(first_call).to equal(second_call)
    end
  end

  describe '#completed_sessions' do
    it 'returns only completed sessions' do
      sessions = [pending_session, planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.completed_sessions).to contain_exactly(completed_session)
    end

    it 'returns empty array when no completed sessions' do
      sessions = [pending_session, planned_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.completed_sessions).to be_empty
    end

    it 'memoizes the result' do
      sessions = [pending_session, planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      first_call = presenter.completed_sessions
      second_call = presenter.completed_sessions

      expect(first_call).to equal(second_call)
    end
  end

  describe '#has_pending_sessions?' do
    it 'returns true when there are pending sessions' do
      sessions = [pending_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.has_pending_sessions?).to be true
    end

    it 'returns false when there are no pending sessions' do
      sessions = [planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.has_pending_sessions?).to be false
    end
  end

  describe '#has_planned_sessions?' do
    it 'returns true when there are planned sessions' do
      sessions = [planned_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.has_planned_sessions?).to be true
    end

    it 'returns false when there are no planned sessions' do
      sessions = [pending_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.has_planned_sessions?).to be false
    end
  end

  describe '#has_completed_sessions?' do
    it 'returns true when there are completed sessions' do
      sessions = [pending_session, completed_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.has_completed_sessions?).to be true
    end

    it 'returns false when there are no completed sessions' do
      sessions = [pending_session, planned_session]
      presenter = PracticeSessionsPresenter.new(sessions)

      expect(presenter.has_completed_sessions?).to be false
    end
  end
end
