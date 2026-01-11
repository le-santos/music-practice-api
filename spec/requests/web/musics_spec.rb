require 'rails_helper'

RSpec.describe 'Web/Musics', type: :request do
  describe 'GET #index' do
    it 'returns success status and a list of musics' do
      user = create(:user)
      5.times { create(:music, user: user, title: 'Custom Music') }
      sign_in(user)

      get '/web/musics'

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Custom Music').exactly(5).times
      expect(response.body).to include('Music Practice Journal')
      expect(response.body).to include('Musics')
      expect(response.body).to include('Practice Sessions')
      expect(response.body).to include(user.email)
      expect(response.body).to include('Sign Out')
    end

    it 'includes action links for each music' do
      user = create(:user)
      music = create(:music, user: user, title: 'Test Music')
      sign_in(user)

      get '/web/musics'

      expect(response).to have_http_status(:success)
      expect(response.body).to include(web_music_path(music))
      expect(response.body).to include(edit_web_music_path(music))
      expect(response.body).to include('View')
      expect(response.body).to include('Edit')
      expect(response.body).to include('Delete')
    end

    it 'includes link to add new music' do
      user = create(:user)
      sign_in(user)

      get '/web/musics'

      expect(response).to have_http_status(:success)
      expect(response.body).to include(new_web_music_path)
      expect(response.body).to include('Add Music')
    end

    it 'redirects page if user not signed in' do
      get '/web/musics'

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end
  end

  describe 'GET #show' do
    it 'returns success status and selected music info' do
      music = create(:music, title: 'Custom Music')
      sign_in(music.user)

      get "/web/musics/#{music.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Custom Music')
    end

    it 'includes edit and back action links' do
      music = create(:music, title: 'Custom Music')
      sign_in(music.user)

      get "/web/musics/#{music.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include(edit_web_music_path(music))
      expect(response.body).to include(web_musics_path)
      expect(response.body).to include('Edit')
      expect(response.body).to include('Back')
    end

    it 'redirects page if user not signed in' do
      music = create(:music)

      get "/web/musics/#{music.id}"

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'redirects page if user does not own resource' do
      user1 = create(:user)
      music = create(:music, title: 'Custom Music', user: user1)
      new_user = create(:user)
      sign_in(new_user)

      get "/web/musics/#{music.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'GET #new' do
    it 'renders form successfully' do
      user = create(:user)
      sign_in(user)

      get '/web/musics/new'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Title')
      expect(response.body).to include('Composer')
      expect(response.body).to include('Back')
    end

    it 'redirects page if user not signed in' do
      get '/web/musics/new'

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'renders page successfully' do
      user = create(:user)
      sign_in(user)

      get '/web/musics/new'

      expect(response).to have_http_status(:ok)
      expect(path).to eq(new_web_music_path)
    end
  end

  describe 'GET #edit' do
    it 'renders the edit path' do
      user = create(:user)
      sign_in(user)
      music = create(:music, user: user)

      get "/web/musics/#{music.id}/edit"

      expect(response).to have_http_status(:success)
      expect(path).to eq(edit_web_music_path(music.id))
    end

    it 'renders the form with music attributes' do
      user = create(:user)
      sign_in(user)
      music = create(:music, user: user, title: 'Test Sonata', composer: 'Mozart')

      get "/web/musics/#{music.id}/edit"

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Test Sonata')
      expect(response.body).to include('Mozart')
      expect(response.body).to include('Title')
    end

    it 'redirects page if user not signed in' do
      user = create(:user)
      music = create(:music, user: user)

      get "/web/musics/#{music.id}/edit"

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'redirects page if user does not own resource' do
      user = create(:user)
      other_user = create(:user)
      other_user_music = create(:music, user: other_user)
      sign_in(user)

      get "/web/musics/#{other_user_music.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'POST #create' do
    it 'redirects page if user not signed in' do
      music_params = {
        music: {
          title: 'Sonata 1',
          composer: 'José das Notas',
          style: 'Popular',
          arranger: 'Maria das Claves',
          category: 'solo'
        }
      }

      post '/web/musics', params: music_params

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'creates new Music for current user when receives required params' do
      user = create(:user)
      sign_in(user)
      music_params = {
        music: {
          title: 'Sonata 1',
          composer: 'José das Notas',
          style: 'Popular',
          arranger: 'Maria das Claves',
          category: 'solo'
        }
      }

      post '/web/musics', params: music_params

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(path).to eq(web_music_path(Music.last.id))
      expect(Music.last.user.id).to eq(user.id)
      expect(flash[:notice]).to eq('Music created successfully.')
    end

    it 'renders NEW action when required params are missing' do
      user = create(:user)
      sign_in(user)
      music_params = {}

      expect { post '/web/musics', params: music_params }.not_to change(Music, :count)
      expect(flash[:error]).to include('Required params are missing')
    end

    it 'does not create resource and render NEW action when music creation fails' do
      user = create(:user)
      sign_in(user)
      music_params = { music: { title: '' } }

      expect { post '/web/musics', params: music_params }.not_to change(Music, :count)
      expect(flash[:error]).to include('Music creation failed.')
    end
  end

  describe 'PATCH #update' do
    it 'redirects page if user does not own resource' do
      user = create(:user)
      other_user = create(:user)
      other_user_music = create(:music, user: other_user)
      sign_in(user)

      patch "/web/musics/#{other_user_music.id}", params: { title: 'New Sonata' }

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

    it 'updates the requested music' do
      user = create(:user)
      sign_in(user)
      music = create(:music, user: user)

      patch "/web/musics/#{music.id}", params: { music: { title: 'New Sonata' } }

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(path).to eq(web_music_path(music.id))
      expect(music.reload.title).to eq('New Sonata')
      expect(flash[:notice]).to eq('Music updated successfully.')
    end

    it 'does not update Music when required params are missing' do
      user = create(:user)
      sign_in(user)
      music = create(:music, user: user)

      patch "/web/musics/#{music.id}", params: {}

      expect(flash[:error]).to include('Required params are missing')
      expect(music.reload.title).not_to eq('')
    end

    it 'does not update Music when update fails' do
      user = create(:user)
      sign_in(user)
      music = create(:music, user: user)

      patch "/web/musics/#{music.id}", params: { music: { title: '' } }

      expect(flash[:error]).to include('Music update failed')
      expect(music.reload.title).not_to eq('')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the requested music' do
      user = create(:user)
      sign_in(user)
      music = create(:music, user: user)

      delete "/web/musics/#{music.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(web_musics_path)
      expect(Music.exists?(music.id)).to be_falsey
      expect(flash[:notice]).to eq('Music deleted successfully.')
    end

    it 'redirects page if user not signed in' do
      user = create(:user)
      music = create(:music, user: user)

      delete "/web/musics/#{music.id}"

      expect(response).to have_http_status(:redirect).and redirect_to('/users/sign_in')
    end

    it 'redirects page if user does not own resource' do
      user = create(:user)
      other_user = create(:user)
      other_user_music = create(:music, user: other_user)
      sign_in(user)

      delete "/web/musics/#{other_user_music.id}"

      expect(response).to have_http_status(:redirect).and redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end
end
