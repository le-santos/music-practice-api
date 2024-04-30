require 'rails_helper'

RSpec.describe 'Musics', type: :request do
  describe 'GET /show' do
    it 'returns status success' do
      music = create(:music)

      get "/musics/#{music.id}"

      expect(response).to have_http_status(:success)
    end
  end
end
