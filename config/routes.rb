Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
      post 'register', to: 'users#create'
      post 'login', to: 'users#login'

      resources 'practice_sessions', only: %i[index show create update destroy]

      resources 'musics', only: %i[index show create update destroy]
    end
  end
end
