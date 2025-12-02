# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PracticeReminders::SendReminderJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }

    context 'when user has not practiced recently' do
      it 'sends a reminder email' do
        mail_stub = instance_double(ActionMailer::MessageDelivery)
        allow(PracticeReminderMailer).to receive(:daily_reminder).and_return(mail_stub)
        allow(mail_stub).to receive(:deliver_later)

        described_class.perform_now(user.id)

        expect(PracticeReminderMailer).to have_received(:daily_reminder).with(user)
        expect(mail_stub).to have_received(:deliver_later)
      end

      it 'logs the reminder sent' do
        mail_stub = instance_double(ActionMailer::MessageDelivery)
        allow(PracticeReminderMailer).to receive(:daily_reminder).with(user).and_return(mail_stub)
        allow(mail_stub).to receive(:deliver_later)
        allow(Rails.logger).to receive(:info)

        described_class.perform_now(user.id)

        expect(Rails.logger).to have_received(:info).with("Reminder sent to user #{user.id}")
      end
    end

    context 'when user practiced within 24 hours' do
      it 'does not send a reminder' do
        create(:practice_session, user: user, created_at: 1.hour.ago)
        mail_stub = instance_double(ActionMailer::MessageDelivery)
        allow(PracticeReminderMailer).to receive(:daily_reminder).and_return(mail_stub)

        described_class.perform_now(user.id)

        expect(PracticeReminderMailer).not_to have_received(:daily_reminder)
      end
    end
  end
end
