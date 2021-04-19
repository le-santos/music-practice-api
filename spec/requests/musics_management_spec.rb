require 'rails_helper'

describe 'Musics routes' do
  context 'GET #index' do
    it 'returns list of Musics' do
      3.times do
        FactoryBot.create(:music)
      end

      get '/api/v1/musics'
      response_json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(Music.last.title)
      expect(response_json.size).to eq(3)
    end

    it 'returns empty array if no resource' do
      get '/api/v1/musics'
      response_json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_json.size).to eq(0)
    end

  end

  context 'GET #show' do
  end

  context 'POST #create' do
  end
  
  context 'PATCH #update' do
  end

  context 'DELETE #destroy' do
  end
end