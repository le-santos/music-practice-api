class PracticeSessionReminder
  include Sidekiq::Worker
  sidekiq_options queue: :notification, retry: 1

  REFERENCE_DATE = DateTime.now - 30.days

  attr_reader :music

  def perform(music_id)
    logger.info('Starting PracticeSessionReminder Job...')

    @music = Music.find_by(id: music_id)
    return unless music

    NotificationClient.new.post(music)
  rescue StandardError => e
    logger.error "Error for music #{music_id}, error: #{e}"
  end

  def logger
    @logger ||= Rails.logger
  end
end
