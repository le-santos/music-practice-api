require 'rails_helper'

describe 'Practice sessions route' do
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:secret) { AuthenticationTokenService::HMAC_SECRET }
  let(:algorithm) { AuthenticationTokenService::ALGORITHM_TYPE }
  let(:user) { create(:user, username: 'user1', password: 'password') }
  let(:payload) {{ user_id: user.id }}
  let(:token) { JWT.encode(payload, secret, algorithm) }
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'GET #index' do
    it 'returns pratice_session list' do
      practice_session1 = FactoryBot.create(:practice_session)
      practice_session2 = FactoryBot.create(:practice_session)

      get '/api/v1/practice_sessions', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response_json[0][:id]).to eq(practice_session1.id)
      expect(response_json[1][:id]).to eq(practice_session2.id)
    end

    it 'return empty array if no content' do
      get '/api/v1/practice_sessions', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response_json.empty?).to be_truthy
    end
  end

  context 'GET #show' do
    it 'return a single practice_session' do
      practice_session = FactoryBot.create(:practice_session)

      get '/api/v1/practice_sessions/1', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response_json[:id]).to eq(practice_session.id)
    end

    it 'return not_found if resource does not exists' do
      get '/api/v1/practice_sessions/1', headers: headers

      expect(response).to have_http_status(:not_found)
      expect(response.body.blank?).to be_truthy
    end
  end

  context 'POST #create' do
    it 'new practice_session' do
      practice_params = { practice_session:
                        { goals: 'Aprender música X',
                          notes: 'Usar o metrônomo hoje' } }

      post '/api/v1/practice_sessions',
           params: practice_params,
           headers: headers

      expect(response).to have_http_status(:created)
      expect(response.body).to include('Usar o metrônomo hoje')
      expect(PracticeSession.last.goals).to eq('Aprender música X')
    end

    it 'cannot have blank goals' do
      practice_params = { practice_session: { goals: '' } }

      post '/api/v1/practice_sessions',
           params: practice_params,
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Metas não pode ficar em branco')
    end
  end

  context 'PATCH #update' do
    it 'updates practice_session' do
      FactoryBot.create(:practice_session)
      practice_update = { practice_session:
                          { goals: 'Aprender música X' } }

      patch '/api/v1/practice_sessions/1',
            params: practice_update,
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Aprender música X')
    end
  end

  context 'DELETE #destroy' do
    it 'deletes practice_session' do
      practice_session = FactoryBot.create(:practice_session)
      count_before = PracticeSession.all.count

      delete "/api/v1/practice_sessions/#{practice_session.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(PracticeSession.count).to be < count_before
    end
  end

  context 'GET #rehearsed_musics' do
    it 'renders musics associated with a practice_session' do
      p_session = FactoryBot.create(:practice_session)
      music1 = FactoryBot.create(:music)
      music2 = FactoryBot.create(:music)
      RehearsedMusic.create!(practice_session: p_session, music: music1)
      RehearsedMusic.create!(practice_session: p_session, music: music2)

      get "/api/v1/practice_sessions/#{p_session.id}/rehearsed_musics", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(music1.title)
      expect(response.body).to include(music2.title)
    end

    it 'renders empty array if no rehearsed_music' do
      p_session = FactoryBot.create(:practice_session)

      get "/api/v1/practice_sessions/#{p_session.id}/rehearsed_musics", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq '[]'
    end
  end
end
