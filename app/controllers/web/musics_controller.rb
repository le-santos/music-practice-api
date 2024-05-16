module Web
  class MusicsController < ApplicationController
    def index
      @musics = Music.where(user: current_user)
    end

    def show
      @music = Music.find(params[:id])
    end
  end
end
