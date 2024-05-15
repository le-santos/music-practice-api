module Web
  class MusicsController < ApplicationController
    def show
      @music = Music.find(params[:id])
    end
  end
end
