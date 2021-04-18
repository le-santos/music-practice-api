require 'rails_helper'

describe 'Practice sessions route' do
  context 'GET' do
    it 'pratice_session list' do
      practice_session = FactoryBot.create(:practice_session)

      get '/api/v1/practice_sessions'
      response_json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_json[0]['id']).to eq(practice_session.id)
    end

    xit 'single practice_session' do
    end
  end
end