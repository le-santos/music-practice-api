require 'rails_helper'

describe 'Musics routes' do
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:secret) { AuthenticationTokenService::HMAC_SECRET }
  let(:algorithm) { AuthenticationTokenService::ALGORITHM_TYPE }
  let(:user) { create(:user, username: 'user1') }
  let(:token) { AuthenticationTokenService.encode(user.email) }
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'GET #index' do
    it 'returns list of Musics' do
      3.times { create(:music) }

      get('/api/v1/musics', headers: headers)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(Music.last.title)
      expect(response_json.size).to eq(3)
    end

    it 'returns empty array if no resource' do
      get('/api/v1/musics', headers: headers)

      expect(response).to have_http_status(:ok)
      expect(response_json.size).to eq(0)
    end
  end

  context 'GET #show' do
    it 'return a single music' do
      music = create(:music)

      get("/api/v1/musics/#{music.id}", headers: headers)

      expect(response).to have_http_status(:ok)
      expect(response_json[:id]).to eq(music.id)
    end

    it 'return a single music with associated practice sessions' do
      music = create(:music)
      2.times { build(:practice_session, music: music) }
      practice_sessions = music.practice_sessions.as_json

      get("/api/v1/musics/#{music.id}", headers: headers)

      expect(response.parsed_body['practice_sessions']).to eq(practice_sessions)
    end

    it 'return not_found if resource does not exists' do
      get('/api/v1/musics/0', headers: headers)

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
                      category: 'solo' } }

      post('/api/v1/musics', params: music, headers: headers)

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

      post('/api/v1/musics', params: music, headers: headers)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Title can't be blank")
      expect(response.body).to include("Composer can't be blank")
      expect(response.body).to include("Style can't be blank")
      expect(response.body).to include("Category can't be blank")
    end
  end

  context 'PATCH #update' do
    let(:music) { create(:music, { composer: 'João Notas' }) }

    it 'updates music attributes successfully' do
      update_params = { music: { composer: 'João Composer' } }

      patch("/api/v1/musics/#{music.id}", params: update_params,
                                          headers: headers)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('João Composer')
      expect(response.body).not_to include('João Notas')
    end

    it 'must have valid attributes' do
      music = create(:music)
      update_params = { music: { composer: '' } }

      patch("/api/v1/musics/#{music.id}", params: update_params,
                                          headers: headers)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Composer can't be blank")
    end
  end

  context 'DELETE #destroy' do
    it 'deletes Music' do
      music = create(:music)
      count_before = Music.count

      delete("/api/v1/musics/#{music.id}", headers: headers)

      expect(response).to have_http_status(:no_content)
      expect(Music.count).to be < count_before
    end
  end
end
