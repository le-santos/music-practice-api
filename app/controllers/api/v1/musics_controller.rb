module Api
  module V1
    class MusicsController < ApiController
      before_action :set_music, only: %i[show]

      def index
        musics = Music.all
        render json: musics, status: :ok
      end

      def show
        return render status: :not_found if @music.nil?

        render json: @music, status: :ok
      end

      private

      def set_music
        @music = Music.find_by(id: params[:id])
      end
    end
  end
end
