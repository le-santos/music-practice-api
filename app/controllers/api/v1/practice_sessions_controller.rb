module Api
  module V1
    class PracticeSessionsController < ApiController
      before_action :set_practice_session,
                    only: %i[show update destroy rehearsed_musics]

      def index
        practice_sessions = PracticeSession.all

        render status: :ok, json: practice_sessions
      end

      def create
        practice_session = PracticeSession.new(practice_params)
        practice_session.user_id = logged_in_user.id

        if practice_session.save
          render status: :created, json: practice_session
        else
          render status: :unprocessable_entity,
                 json: practice_session.errors.full_messages
        end
      end

      def show
        return render status: :not_found if @practice_session.nil?

        render status: :ok, json: @practice_session
      end

      def update
        if @practice_session.update(practice_params)
          render status: :ok, json: @practice_session
        else
          render status: :unprocessable_entity,
                 json: @practice_session.errors.full_messages
        end
      end

      def destroy
        @practice_session.destroy
      end

      def rehearsed_musics
        return render status: :ok, json: [] if @practice_session.musics.empty?

        render status: :ok, json: @practice_session.musics
      end

      private

      def set_practice_session
        @practice_session = PracticeSession.find_by(id: params[:id])
      end

      def practice_params
        params.require(:practice_session).permit(:goals, :notes, :attachments)
      end
    end
  end
end
