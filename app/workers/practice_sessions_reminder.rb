class PracticeSessionsReminder
  include Sidekiq::Worker
  sidekiq_options queue: :notification, retry: 1

  REFERENCE_DATE = DateTime.now - 30.days

  def perform
    logger.info('Starting PracticeSessionsReminder Job...')

    musics.find_each.with_index do |music, index|
      PracticeSessionReminder.perform_in(index, music.id)
    end
  rescue StandardError => e
    logger.error "Error: #{e}"
  end

  def logger
    @logger ||= Rails.logger
  end

  def musics
    @musics ||= Music.where('last_played < ?', REFERENCE_DATE).select(:id)
  end
end
