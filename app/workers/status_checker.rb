class StatusChecker
  include Sidekiq::Worker
  sidekiq_options :queue => :default , :retry => 1

  
  def perform
    PracticeSession.all.each do |practice|
      case practice.status
      when 'pending'
        puts 'Go plan your practice'
      when 'planned'
        puts 'Go practice'
      else
        puts 'Good Job'
      end
    end

  rescue StandardError => e
    puts "Error for practice_session id: #{practice_session_id}"
  end
end
