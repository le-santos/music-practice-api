class MusicReminder
  include Sidekiq::Worker
  sidekiq_options :queue => :notification , :retry => 1

  
  def perform
    reference_date = DateTime.now - 30.days
    puts 'running Worker'

    musics = Music.all
    musics.each do |music|
      next unless music.last_played < reference_date

      music.archived!
      message = "You should remember and practice music #{music.title}"
      puts message
      # body = { message: message }
      # NotificationClient.new.post(body)
    end

  rescue StandardError => e
    puts "Error for music #{e}"
  end
end
