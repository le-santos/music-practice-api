module Api
  module V1
    class MusicsController < ApiController
      def index
        musics = Music.all
        render json: musics, status: :ok
      end
    end
  end
end
