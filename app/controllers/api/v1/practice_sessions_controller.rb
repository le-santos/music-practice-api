module Api
  module V1
    class PracticeSessionsController < ApiController
      def index
        practice_sessions = PracticeSession.all

        render status: :ok, json: practice_sessions
      end

      def show
        practice_session = PracticeSession.find(params[:id])

        render status: :ok, json: practice_session
      end
    end
  end
end
