module Web
  class MusicsController < ApplicationController
    def index
      @musics = policy_scope(Music)
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
      authorize @music

      if @music.save
        redirect_to web_music_url(@music), notice: t('.success')
      else
        flash.now[:error] = format_errors(@music)
        render :new
      end
    end

    def update
      @music = authorize Music.find(params[:id])

      if @music.update(music_params)
        redirect_to web_music_url(@music), notice: t('.success')
      else
        flash.now[:error] = format_errors(@music)
        render :edit
      end
    end

    def destroy
      @music = authorize Music.find(params[:id])

      @music.destroy!
      redirect_to web_musics_url, notice: t('.success')
    end

    private

    def format_errors(record)
      "#{t('.failure')} #{record.errors.full_messages.join(', ')}"
    end

    def music_params
      params
        .require(:music)
        .permit(:title, :composer, :style, :arranger, :category)
    end
  end
end
