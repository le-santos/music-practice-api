require 'rails_helper'

describe 'Musics routes' do
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:secret) { AuthenticationTokenService::HMAC_SECRET }
  let(:algorithm) { AuthenticationTokenService::ALGORITHM_TYPE }
  let(:user) { create(:user, username: 'user1', password: 'password') }
  let(:token) { AuthenticationTokenService.encode(user.email) }
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'GET #index' do
    it 'returns list of Musics' do
      3.times { create(:music) }

      get '/api/v1/musics', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(Music.last.title)
      expect(response_json.size).to eq(3)
    end

    it 'returns empty array if no resource' do
      get '/api/v1/musics', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response_json.size).to eq(0)
    end
  end

  context 'GET #show' do
  
  it 'return a single music' do
      music = create(:music)

      get "/api/v1/musics/#{music.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response_json[:id]).to eq(music.id)
    end

    it 'return not_found if resource does not exists' do
      get "/api/v1/musics/0", headers: headers

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
                      last_played: Time.zone.today } }

      post '/api/v1/musics', params: music, headers: headers

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

      post '/api/v1/musics', params: music, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Título não pode ficar em branco')
      expect(response.body).to include('Compositor não pode ficar em branco')
      expect(response.body).to include('Estilo não pode ficar em branco')
      expect(response.body).to include('Categoria não pode ficar em branco')
    end
  end

  context 'PATCH #update' do
    let(:music) { create(:music, { composer: 'João Notas' }) }

    it 'updates music attributes successfully' do
      update_params = { music:
                        { composer: 'João Composer',
                          last_played: 1.day.ago } }

      patch "/api/v1/musics/#{music.id}", params: update_params, headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('João Composer')
      expect(response.body).not_to include('João Notas')
    end

    it 'must have valid attributes' do
      music = create(:music)
      update_params = { music: { composer: '' } }

      patch "/api/v1/musics/#{music.id}", params: update_params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Compositor não pode ficar em branco')
    end
  end

  context 'DELETE #destroy' do
    it 'deletes Music' do
      music = create(:music)
      count_before = Music.all.count

      delete "/api/v1/musics/#{music.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(Music.all.count).to be < count_before
    end
  end

  context 'GET #rehearsed_sessions' do
    it 'renders practice_sessions associated with a music' do
      music = create(:music)
      p_session1 = create(:practice_session)
      p_session2 = create(:practice_session)
      RehearsedMusic.create!(practice_session: p_session1, music: music)
      RehearsedMusic.create!(practice_session: p_session2, music: music)

      get "/api/v1/musics/#{music.id}/rehearsed_sessions", headers: headers
      response_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(response_json.count).to be(2)
      expect(response_json[0][:id]).to eq(p_session1.id)
      expect(response_json[1][:id]).to eq(p_session2.id)
    end

    it 'renders empty array if no practice_session' do
      music = create(:music)

      get "/api/v1/musics/#{music.id}/rehearsed_sessions", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq '[]'
    end
  end
end
