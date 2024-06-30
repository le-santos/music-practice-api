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

  describe 'GET /new' do
    it 'redirects page if user not signed in' do
      get '/web/musics/new'

      expect(response).to have_http_status(:redirect)
    end

    it 'renders page successfully' do
      user = create(:user)
      sign_in(user)

      get '/web/musics/new'

      expect(response).to have_http_status(:ok)
      expect(path).to eq(new_web_music_path)
    end
  end

  describe 'POST /create' do
    it 'redirects page if user not signed in' do
      music_params = {
        title: 'Sonata 1',
        composer: 'José das Notas',
        style: 'Popular',
        arranger: 'Maria das Claves',
        category: 'solo'
      }

      post '/web/musics', params: music_params

      expect(response).to have_http_status(:redirect)
    end

    it 'creates new Music for current user when receives required params' do
      user = create(:user)
      sign_in(user)
      music_params = {
        title: 'Sonata 1',
        composer: 'José das Notas',
        style: 'Popular',
        arranger: 'Maria das Claves',
        category: 'solo'
      }

      post '/web/musics', params: music_params

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(path).to eq(web_music_path(Music.last.id))
      expect(Music.last.user.id).to eq(user.id)
      expect(flash[:notice]).to eq('Music created sucessfully.')
    end

    it 'does not create resource and render NEW action when missing params' do
      user = create(:user)
      sign_in(user)
      music_params = { title: '' }

      expect { post '/web/musics', params: music_params }.not_to change(Music, :count)
      expect(flash[:error]).to include('Music creation failed.')
    end
  end
end
