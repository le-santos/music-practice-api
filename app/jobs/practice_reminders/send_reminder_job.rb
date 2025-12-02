# frozen_string_literal: true

module PracticeReminders
  class SendReminderJob < ApplicationJob
    queue_as :default

    # Retry up to 3 times with exponential backoff (3s, 9s, 27s)
    retry_on StandardError, wait: :exponentially_longer, attempts: 3

    # Discard if user was deleted before job executes
    discard_on ActiveJob::DeserializationError

    # Prevent duplicate reminders on same day for same user
    # idempotency_key { "practice_reminder_#{arguments[0]}_#{Date.current}" }

    def perform(user_id)
      user = User.find(user_id)
      return if user.practice_sessions.exists?(['created_at >= ?', 24.hours.ago])

      PracticeReminderMailer.daily_reminder(user).deliver_later

      Rails.logger.info("Reminder sent to user #{user_id}")
    rescue StandardError => e
      Rails.logger.error("Failed to send reminder to user #{user_id}: #{e.message}")
      raise e
    end
  end
end
