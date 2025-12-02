# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PracticeReminders::DailyRemindersJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'schedules reminder for users who need it' do
      user1 = create(:user)
      user2 = create(:user)
      create(:practice_session, user: user2, created_at: 1.hour.ago)
      clear_enqueued_jobs

      expect { described_class.perform_now }
        .to have_enqueued_job(PracticeReminders::SendReminderJob)
        .with(user1.id)
    end

    it 'does not schedule for users who practiced recently' do
      user1 = create(:user)
      user2 = create(:user)
      create(:practice_session, user: user2, created_at: 1.hour.ago)
      clear_enqueued_jobs

      expect { described_class.perform_now }
        .to have_enqueued_job(PracticeReminders::SendReminderJob)
        .with(user1.id)
    end
  end
end
