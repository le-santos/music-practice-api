require 'rails_helper'

RSpec.describe 'PracticeSessions', type: :request do
  describe 'GET /index' do
    it 'returns success status and a list of practice sessions', :aggregate_failures do
      user = create(:user)
      2.times { create(:practice_session, user: user) }
      sign_in(user)

      get '/web/practice_sessions'

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Practice Session for Music').exactly(2).times
    end

    it 'includes action links for each practice session', :aggregate_failures do
      user = create(:user)
      practice_session = create(:practice_session, user: user)
      sign_in(user)

      get '/web/practice_sessions'

      expect(response).to have_http_status(:success)
      expect(response.body).to include(web_practice_session_path(practice_session))
      expect(response.body).to include(edit_web_practice_session_path(practice_session))
      expect(response.body).to include('View')
      expect(response.body).to include('Edit')
      expect(response.body).to include('Delete')
    end

    it 'includes link to create new practice session', :aggregate_failures do
      user = create(:user)
      sign_in(user)

      get '/web/practice_sessions'

      expect(response).to have_http_status(:success)
      expect(response.body).to include(new_web_practice_session_path)
      expect(response.body).to include('New Practice Session')
    end

    it 'redirects page if user not signed in' do
      get '/web/practice_sessions'

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end
  end

  describe 'GET /show' do
    it 'returns status success when user is signed in', :aggregate_failures do
      practice_session = create(:practice_session, goals: 'practice c minor scale')
      sign_in(practice_session.user)

      get "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include('practice c minor scale')
    end

    it 'includes edit and back action links', :aggregate_failures do
      practice_session = create(:practice_session, goals: 'practice c minor scale')
      sign_in(practice_session.user)

      get "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include(edit_web_practice_session_path(practice_session))
      expect(response.body).to include(web_practice_sessions_path)
      expect(response.body).to include('Edit')
      expect(response.body).to include('Back')
    end

    it 'redirects page if user not signed in' do
      practice_session = create(:practice_session)

      get "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:redirect)
    end

    it 'redirects page if user does not own resource' do
      user1 = create(:user)
      practice_session = create(:practice_session, user: user1)
      new_user = create(:user)
      sign_in(new_user)

      get "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      follow_redirect!
      expect(flash[:alert]).to be_present
    end
  end

  describe 'GET /new' do
    it 'renders form successfully', :aggregate_failures do
      user = create(:user)
      sign_in(user)

      get '/web/practice_sessions/new'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('form')
      expect(response.body).to include('Back')
    end

    it 'redirects page if user not signed in' do
      get '/web/practice_sessions/new'

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end
  end

  describe 'GET /edit' do
    it 'renders the edit path', :aggregate_failures do
      user = create(:user)
      sign_in(user)
      practice_session = create(:practice_session, user: user)

      get "/web/practice_sessions/#{practice_session.id}/edit"

      expect(response).to have_http_status(:success)
      expect(path).to eq(edit_web_practice_session_path(practice_session.id))
    end

    it 'renders the form with practice session attributes', :aggregate_failures do
      user = create(:user)
      sign_in(user)
      practice_session = create(:practice_session, user: user, goals: 'Test Goal')

      get "/web/practice_sessions/#{practice_session.id}/edit"

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Test Goal')
      expect(response.body).to include('form')
    end

    it 'redirects page if user not signed in' do
      user = create(:user)
      practice_session = create(:practice_session, user: user)

      get "/web/practice_sessions/#{practice_session.id}/edit"

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'redirects page if user does not own resource', :aggregate_failures do
      user = create(:user)
      other_user = create(:user)
      other_user_ps = create(:practice_session, user: other_user)
      sign_in(user)

      get "/web/practice_sessions/#{other_user_ps.id}/edit"

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'POST /create' do
    it 'redirects page if user not signed in' do
      practice_session_params = {
        practice_session: {
          music_id: create(:music).id,
          goals: 'Practice goals',
          status: 'pending'
        }
      }

      post '/web/practice_sessions', params: practice_session_params

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'creates new PracticeSession for current user', :aggregate_failures do
      user = create(:user)
      sign_in(user)
      music = create(:music, user: user)
      practice_session_params = {
        practice_session: {
          music_id: music.id,
          goals: 'Practice goals',
          status: 'pending'
        }
      }

      post '/web/practice_sessions', params: practice_session_params

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(path).to eq(web_practice_session_path(PracticeSession.last.id))
      expect(PracticeSession.last.user.id).to eq(user.id)
      expect(flash[:notice]).to be_present
    end
  end

  describe 'PATCH /update' do
    it 'redirects page if user does not own resource', :aggregate_failures do
      user = create(:user)
      other_user = create(:user)
      other_user_ps = create(:practice_session, user: other_user)
      sign_in(user)

      patch "/web/practice_sessions/#{other_user_ps.id}",
            params: { practice_session: { goals: 'New Goal' } }

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

    it 'updates the requested practice session', :aggregate_failures do
      user = create(:user)
      sign_in(user)
      practice_session = create(:practice_session, user: user, goals: 'Old Goal')

      patch "/web/practice_sessions/#{practice_session.id}",
            params: { practice_session: { goals: 'New Goal' } }

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(path).to eq(web_practice_session_path(practice_session.id))
      expect(practice_session.reload.goals).to eq('New Goal')
      expect(flash[:notice]).to be_present
    end

    it 'redirects page if user not signed in' do
      practice_session = create(:practice_session)

      patch "/web/practice_sessions/#{practice_session.id}",
            params: { practice_session: { goals: 'New Goal' } }

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the requested practice session', :aggregate_failures do
      user = create(:user)
      sign_in(user)
      practice_session = create(:practice_session, user: user)

      delete "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(web_practice_sessions_path)
      expect(PracticeSession.exists?(practice_session.id)).to be_falsey
      expect(flash[:notice]).to be_present
    end

    it 'redirects page if user not signed in' do
      user = create(:user)
      practice_session = create(:practice_session, user: user)

      delete "/web/practice_sessions/#{practice_session.id}"

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'redirects page if user does not own resource', :aggregate_failures do
      user = create(:user)
      other_user = create(:user)
      other_user_ps = create(:practice_session, user: other_user)
      sign_in(user)

      delete "/web/practice_sessions/#{other_user_ps.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end
end
