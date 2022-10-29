require 'rails_helper'

RSpec.describe PracticeSessionsReminder, type: :job do
  context 'job setup' do
    it { is_expected.to be_processed_in :notification }
  end

  context '#perform_at' do
    it 'enqueue job at scheduled time' do
      time = 10.seconds.from_now
      PracticeSessionsReminder.perform_at(time, 'PracticeReminder')

      expect(PracticeSessionsReminder).to have_enqueued_sidekiq_job('PracticeReminder').at(time)
    end
  end
end
