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
    it 'new music' do
      music = { music:
                    { title: 'Sonata 1',
                      composer: 'José das Notas',
                      style: 'Popular',
                      arranger: 'Maria das Claves',
                      category: 'solo',
                      last_played: Date.today } }

      post '/api/v1/musics', params: music

      expect(response).to have_http_status(:created)
      expect(response.body).to include('José das Notas')
      expect(Music.last.title).to eq('Sonata 1')
    end

    it 'cannot have blank attributes' do
      music = { music:
                    { title: '',
                      composer: '',
                      style: '',
                      category: '' } }

      post '/api/v1/musics', params: music

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Título não pode ficar em branco')
      expect(response.body).to include('Compositor não pode ficar em branco')
      expect(response.body).to include('Estilo não pode ficar em branco')
      expect(response.body).to include('Categoria não pode ficar em branco')
    end
  end

  context 'PATCH #update' do
  end

  context 'DELETE #destroy' do
  end
end