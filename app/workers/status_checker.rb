class StatusChecker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform
    PracticeSession.all.each do |practice|
      case practice.status
      when 'pending'
        logger.info "Go plan your practice id: #{practice.id}"
      when 'planned'
        logger.info "Go practice session #{practice.id}"
      else
        logger.info "Good Job, session #{practice.id} is done"
      end
    end
  end

  def logger
    @logger ||= Rails.logger
  end
end
