Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
      resources 'practice_sessions', only: %i[index show create update destroy] do
        get 'rehearsed_musics', to: 'practice_sessions#rehearsed_musics', on: :member
      end

      resources 'musics', only: %i[index show create update destroy] do
        get 'rehearsed_sessions', to: 'musics#rehearsed_sessions', on: :member
      end
    end
  end

end
