class MusicReminder
  include Sidekiq::Worker
  sidekiq_options queue: :notification, retry: 1

  REFERENCE_DATE = DateTime.now - 30.days

  def perform
    logger.info('Starting MusicReminder Job...')
    forgotten_music = []

    musics.each do |music|
      next unless music.last_played < REFERENCE_DATE

      forgotten_music << music.title
      logger.info("You should remember and practice music #{music.title}")
    end

    NotificationClient.new.post({ musics_to_remember: forgotten_music })
  rescue StandardError => e
    logger.error "Error for music #{e}"
  end

  def logger
    @logger ||= Rails.logger
  end

  def musics
    @musics ||= Music.all
  end
end
