require 'rails_helper'

RSpec.describe 'Musics', type: :request do
  describe 'GET /index' do
    it 'returns success status and a list of musics' do
      user = create(:user)
      5.times { create(:music, user: user, title: 'Custom Music') }
      sign_in(user)

      get '/web/musics'

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Custom Music').exactly(5).times
    end

    it 'redirects page if user not signed in' do
      get '/web/musics'

      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET /show' do
    it 'returns success status and selected music info' do
      music = create(:music, title: 'Custom Music')
      sign_in(music.user)

      get "/web/musics/#{music.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Custom Music')
    end

    it 'redirects page if user not signed in' do
      music = create(:music)

      get "/web/musics/#{music.id}"

      expect(response).to have_http_status(:redirect)
    end

    it 'redirects page if user does not own resource' do
      user1 = create(:user)
      music = create(:music, title: 'Custom Music', user: user1)
      new_user = create(:user)
      sign_in(new_user)

      get "/web/musics/#{music.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      follow_redirect!
      expect(flash[:alert]).to be_present
    end
  end
end
