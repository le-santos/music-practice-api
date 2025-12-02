# frozen_string_literal: true

class PracticeReminderMailer < ApplicationMailer
  def daily_reminder(user)
    @user = user
    mail(to: user.email, subject: 'Time to practice! 🎵')
  end
end
