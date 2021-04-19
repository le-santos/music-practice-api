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
    it 'return a single music' do
      music = FactoryBot.create(:music)

      get '/api/v1/musics/1'
      response_json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_json['id']).to eq(music.id)
    end

    it 'return not_found if resource does not exists' do
      get '/api/v1/musics/1'

      expect(response).to have_http_status(:not_found)
      expect(response.body.blank?).to be_truthy
    end
  end

  context 'POST #create' do
  end
  
  context 'PATCH #update' do
  end

  context 'DELETE #destroy' do
  end
end