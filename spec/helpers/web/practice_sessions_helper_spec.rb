require 'rails_helper'

RSpec.describe Web::PracticeSessionsHelper do
  describe '#practice_session_status_badge_classes' do
    it 'returns pending classes for pending status' do
      expect(helper.practice_session_status_badge_classes('pending'))
        .to eq('bg-yellow-100 text-yellow-800')
    end

    it 'returns planned classes for planned status' do
      expect(helper.practice_session_status_badge_classes('planned'))
        .to eq('bg-blue-100 text-blue-800')
    end

    it 'returns completed classes for completed status' do
      expect(helper.practice_session_status_badge_classes('completed'))
        .to eq('bg-green-100 text-green-800')
    end

    it 'returns default classes for unknown status' do
      expect(helper.practice_session_status_badge_classes('unknown'))
        .to eq('bg-gray-100 text-gray-800')
    end

    it 'returns default classes for nil' do
      expect(helper.practice_session_status_badge_classes(nil))
        .to eq('bg-gray-100 text-gray-800')
    end
  end
end
