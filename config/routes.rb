Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
      resources 'practice_sessions', only: %i[index show]
    end
  end

end
