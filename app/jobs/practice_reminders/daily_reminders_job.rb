# frozen_string_literal: true

module PracticeReminders
  class DailyRemindersJob < ApplicationJob
    queue_as :default

    def perform
      users_needing_reminders = User.missing_practice_since(24.hours.ago)
      users_needing_reminders.find_each do |user|
        PracticeReminders::SendReminderJob.perform_later(user.id)
      end

      Rails.logger.info('Scheduled  reminder jobs')
    end
  end
end
