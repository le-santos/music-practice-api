require 'rails_helper'

describe 'Practice sessions route' do
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:secret) { AuthenticationTokenService::HMAC_SECRET }
  let(:algorithm) { AuthenticationTokenService::ALGORITHM_TYPE }
  let(:user) { create(:user, username: 'user1', password: 'password') }
  let(:payload) { { email: user.email } }
  let(:token) { JWT.encode(payload, secret, algorithm) }
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'GET #index' do
    it 'returns pratice_session list' do
      practice_session1 = create(:practice_session)
      practice_session2 = create(:practice_session)

      get('/api/v1/practice_sessions', headers:)

      expect(response).to have_http_status(:ok)
      expect(response_json[0][:id]).to eq(practice_session1.id)
      expect(response_json[1][:id]).to eq(practice_session2.id)
    end

    it 'return empty array if no content' do
      get('/api/v1/practice_sessions', headers:)

      expect(response).to have_http_status(:ok)
      expect(response_json.empty?).to be_truthy
    end
  end

  context 'GET #show' do
    it 'returns a single practice_session' do
      practice_session = create(:practice_session)

      get("/api/v1/practice_sessions/#{practice_session.id}", headers:)

      expect(response).to have_http_status(:ok)
      expect(response_json[:id]).to eq(practice_session.id)
    end

    it 'return not_found if resource does not exists' do
      get('/api/v1/practice_sessions/1', headers:)

      expect(response).to have_http_status(:not_found)
      expect(response.body.blank?).to be_truthy
    end
  end

  context 'POST #create' do
    it 'creates new practice_session' do
      music = create(:music)
      practice_params = {
        practice_session: {
          goals: 'Ler parte B',
          music_id: music.id,
          notes: 'Usar o metrônomo hoje'
        }
      }

      post('/api/v1/practice_sessions',
           params: practice_params,
           headers:)

      expect(response).to have_http_status(:created)
      expect(response.body).to include('Usar o metrônomo hoje')
      expect(PracticeSession.last.goals).to eq('Ler parte B')
    end

    context 'with empty goals' do
      it 'returns unprocessable entity' do
        practice_params = { practice_session: { goals: '' } }

        post('/api/v1/practice_sessions',
             params: practice_params,
             headers:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Metas não pode ficar em branco')
      end
    end
  end

  context 'PATCH #update' do
    it 'updates practice_session' do
      practice_session = create(:practice_session)
      practice_update = { practice_session: { goals: 'Ler parte C' } }

      patch("/api/v1/practice_sessions/#{practice_session.id}",
            params: practice_update,
            headers:)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Ler parte C')
    end
  end

  context 'DELETE #destroy' do
    it 'deletes practice_session' do
      practice_session = create(:practice_session)

      expect do
        delete("/api/v1/practice_sessions/#{practice_session.id}", headers:)
      end.to change(PracticeSession, :count).to 0

      expect(response).to have_http_status(:no_content)
    end
  end
end
