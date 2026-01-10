module Web::MusicsHelper
  def status_badge_classes(status)
    case status
    when 'archived'
      'bg-gray-100 text-gray-800'
    when 'learning'
      'bg-blue-100 text-blue-800'
    when 'reviewing'
      'bg-purple-100 text-purple-800'
    when 'performing'
      'bg-green-100 text-green-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
