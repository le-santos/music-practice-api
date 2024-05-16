require 'rails_helper'

RSpec.describe 'PracticeSessions', type: :request do
  describe 'GET /index' do
    it 'returns success status and a list of practice sessions' do
      user = create(:user)
      5.times { create(:practice_session, user: user) }
      sign_in(user)

      get '/web/practice_sessions'

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Practice Session for Music').exactly(5).times
    end

    it 'redirects page if user not signed in' do
      practice_session = create(:practice_session)

      get "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET /show' do
    it 'returns status success when user is signed in' do
      practice_session = create(:practice_session, goals: 'practice c minor scale')
      sign_in(practice_session.user)

      get "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include('practice c minor scale')
    end

    it 'redirects page if user not signed in' do
      practice_session = create(:practice_session)

      get "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:redirect)
    end
  end
end
