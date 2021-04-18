module Api
  module V1
    class PracticeSessionsController < ApiController
      def index
        practice_session = PracticeSession.all

        render status: :ok, json: practice_session
      end
    end
  end
end
