module Web
  class MusicsController < ApplicationController
    def index
      @musics = Music.where(user: current_user)
    end

    def new; end

    def show
      @music = authorize Music.find(params[:id])
    end

    def create
      @music = current_user.musics.new(music_params)

      if @music.save
        flash[:notice] = 'Music Created' #I18n.t(:music_created)
        redirect_to web_music_url(@music)
      else
        flash.now[:error] = 'Music not created, missing params' #I18n.t(:params_missing)
        render :new
      end
    end

    private

    def music_params
      params
        .require(:music)
        .permit(:title, :composer, :style, :arranger,
                :category, :last_played, :status)
    end
  end
end
