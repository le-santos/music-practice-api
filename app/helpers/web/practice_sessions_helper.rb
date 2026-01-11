module Web
  module PracticeSessionsHelper
    def practice_session_status_badge_classes(status)
      case status
      when 'pending'
        'bg-yellow-100 text-yellow-800'
      when 'planned'
        'bg-blue-100 text-blue-800'
      when 'completed'
        'bg-green-100 text-green-800'
      else
        'bg-gray-100 text-gray-800'
      end
    end
  end
end
