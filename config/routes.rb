require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace 'api' do
    namespace 'v1' do
      post 'register', to: 'users#create'
      post 'login', to: 'users#login'

      resources 'practice_sessions', only: %i[index show create update destroy] do
        get 'rehearsed_musics', to: 'practice_sessions/rehearsed_musics#index', on: :member
      end

      resources 'musics', only: %i[index show create update destroy]
    end
  end
end
