module Api
  module V1
    module PracticeSessions
      class RehearsedMusicsController < ApiController
        before_action :find_practice_session, only: :index
        rescue_from ActiveRecord::RecordNotFound, with: :not_found

        def index
          render json: rehearsed_musics, status: :ok
        end

        private

        def find_practice_session
          @practice_session = PracticeSession.find(params[:id])
        end

        def rehearsed_musics
          @practice_session.musics
        end

        def not_found(exception)
          render json: exception.message, status: :not_found
        end
      end
    end
  end
end
