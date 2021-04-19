require 'rails_helper'

describe 'Practice sessions route' do
  context 'GET' do
    it 'pratice_session list (INDEX)' do
      practice_session1 = FactoryBot.create(:practice_session)
      practice_session2 = FactoryBot.create(:practice_session)

      get '/api/v1/practice_sessions'
      response_json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_json[0]['id']).to eq(practice_session1.id)
      expect(response_json[1]['id']).to eq(practice_session2.id)
    end

    it 'single practice_session (SHOW)' do
      practice_session = FactoryBot.create(:practice_session)

      get '/api/v1/practice_sessions/1'
      response_json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_json['id']).to eq(practice_session.id)
    end
  end
end
