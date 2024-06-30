module Web
  class MusicsController < ApplicationController
    def index
      @musics = Music.where(user: current_user)
    end

    def show
      @music = authorize Music.find(params[:id])
    end

    def new
      @music = current_user.musics.new
    end

    def edit
      @music = authorize Music.find(params[:id])
    end

    def create
      @music = current_user.musics.new(music_params)

      if @music.save
        redirect_to web_music_url(@music), notice: t('.success')
      else
        flash.now[:error] = "#{t('.failure')} #{@music.errors.full_messages.join(', ')}"
        render :new
      end
    end

    def update
      @music = authorize Music.find(params[:id])

      if @music.update(music_params)
        redirect_to web_music_url(@music), notice: t('.success')
      else
        flash.now[:error] = "#{t('.failure')} #{@music.errors.full_messages.join(', ')}"
        render :edit
      end
    end

    def destroy
      @music = authorize Music.find(params[:id])

      @music.destroy!
      redirect_to web_musics_url, notice: t('.success')
    end

    private

    def music_params
      params
        .require(:music)
        .permit(:title, :composer, :style, :arranger, :category)
    end
  end
end
