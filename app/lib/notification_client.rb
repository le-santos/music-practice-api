require 'faraday'

class NotificationClient
  NOTIFICATION_URL = ENV['WEBHOOK_URL']

  def post(body)
    connection.post('/', body.to_json)
  end

  private

  def connection
    connection ||= Faraday.new(NOTIFICATION_URL) do |f|
      f.request :json
      f.response :json
    end
  end
end
