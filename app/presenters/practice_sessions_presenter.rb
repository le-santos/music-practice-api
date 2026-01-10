class PracticeSessionsPresenter
  def initialize(practice_sessions)
    @practice_sessions = practice_sessions
  end

  def pending_sessions
    @pending_sessions ||= @practice_sessions.select { |ps| ps.status == 'pending' }
  end

  def planned_sessions
    @planned_sessions ||= @practice_sessions.select { |ps| ps.status == 'planned' }
  end

  def completed_sessions
    @completed_sessions ||= @practice_sessions.select { |ps| ps.status == 'completed' }
  end

  def has_pending_sessions?
    pending_sessions.any?
  end

  def has_planned_sessions?
    planned_sessions.any?
  end

  def has_completed_sessions?
    completed_sessions.any?
  end
end
