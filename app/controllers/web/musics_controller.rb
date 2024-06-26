module Web
  class MusicsController < ApplicationController
    def index
      @musics = Music.where(user: current_user)
    end

    def show
      @music = authorize Music.find(params[:id])
    end

    def new; end

    def create
      @music = current_user.musics.new(music_params)

      if @music.save
        redirect_to web_music_url(@music), notice: t('.success')
      else
        flash.now[:error] = "#{t('.failure')} #{@music.errors.full_messages.join(', ')}"
        render :new
      end
    end

    private

    def music_params
      params.permit(:title, :composer, :style, :arranger, :category, :status)
    end
  end
end
