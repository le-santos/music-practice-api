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

      def create
        music = Music.new(music_params)

        if music.save
          render status: :created, json: music
        else
          #render status: :unprocessable_entity,
          #       json: music.errors.full_messages
        end
      end

      private

      def set_music
        @music = Music.find_by(id: params[:id])
      end

      def music_params
        params.require(:music).permit(:title, :composer, 
                                      :style, :arranger, 
                                      :category, :last_played, :status)
      end
    end
  end
end
