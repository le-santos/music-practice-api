require 'rails_helper'

RSpec.describe Web::MusicsHelper do
  describe '#status_badge_classes' do
    it 'returns archived classes for archived status' do
      expect(helper.status_badge_classes('archived')).to eq('bg-gray-100 text-gray-800')
    end

    it 'returns learning classes for learning status' do
      expect(helper.status_badge_classes('learning')).to eq('bg-blue-100 text-blue-800')
    end

    it 'returns reviewing classes for reviewing status' do
      expect(helper.status_badge_classes('reviewing')).to eq('bg-purple-100 text-purple-800')
    end

    it 'returns performing classes for performing status' do
      expect(helper.status_badge_classes('performing')).to eq('bg-green-100 text-green-800')
    end

    it 'returns default classes for unknown status' do
      expect(helper.status_badge_classes('unknown')).to eq('bg-gray-100 text-gray-800')
    end

    it 'returns default classes for nil' do
      expect(helper.status_badge_classes(nil)).to eq('bg-gray-100 text-gray-800')
    end
  end
end
