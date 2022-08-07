module Api
  module V1
    class PracticeSessionsController < ApiController
      before_action :set_practice_session, only: %i[show update destroy]

      def index
        practice_sessions = PracticeSession.all

        render status: :ok, json: practice_sessions
      end

      def create
        practice_session = build_practice_session_and_associations

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

      private

      def set_practice_session
        @practice_session = PracticeSession.find_by(id: params[:id])
      end

      # TODO: this logic should be in a service outside this controller
      def build_practice_session_and_associations
        PracticeSession.new(practice_params).tap do |practice|
          practice.user_id = logged_in_user.id

          music_from_params.each do |music|
            practice.rehearsed_musics.build(music_id: music.id, practice_session_id: practice.id)
          end
        end
      end

      def music_from_params
        Music.where(id: valid_params.fetch(:musics, []))
      end

      def valid_params
        params.require(:practice_session).permit(:goals, :notes, :attachments, { musics: [] })
      end

      def practice_params
        valid_params.except(:musics)
      end
    end
  end
end
