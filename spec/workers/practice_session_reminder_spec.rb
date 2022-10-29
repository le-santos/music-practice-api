require 'rails_helper'

RSpec.describe PracticeSessionReminder, type: :job do
  context 'job setup' do
    it { is_expected.to be_processed_in :notification }
    it { is_expected.to be_retryable 1 }
  end

  context '#perform_at' do
    it 'enqueue job at scheduled time' do
      music_id = create(:music).id
      time = 10.seconds.from_now
      PracticeSessionReminder.perform_at(time, music_id)

      expect(PracticeSessionReminder).to have_enqueued_sidekiq_job(music_id).at(time)
    end
  end
end
