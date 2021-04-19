module Api
  module V1
    class PracticeSessionsController < ApiController
      def index
        practice_sessions = PracticeSession.all

        render status: :ok, json: practice_sessions
      end

      def create
        practice_session = PracticeSession.new(practice_params)

        if practice_session.save
          render status: :created, json: practice_session
        else
          render status: :unprocessable_entity,
                 json: practice_session.errors.full_messages
        end
      end

      def show
        practice_session = PracticeSession.find_by(id: params[:id])

        return render status: :not_found if practice_session.nil?

        render status: :ok, json: practice_session
      end

      private

      def practice_params
        params.require(:practice_session).permit(:goals, :notes, :attachments)
      end
    end
  end
end
