module Web
  class PracticeSessionsController < ApplicationController
    def index
      @practice_sessions = PracticeSession.where(user: current_user)
    end

    def show
      @practice_session = authorize PracticeSession.find(params[:id])
    end

    def new
      @musics = current_user.musics.pluck(:title, :id)
      @practice_session = current_user.practice_sessions.new
    end

    def edit
      @practice_session = authorize PracticeSession.find(params[:id])
      @musics = current_user.musics.pluck(:title, :id)
    end

    def create
      # should authorize if current_user really owns the related to this music_id?
      @practice_session = current_user.practice_sessions.create!(practice_session_params)

      redirect_to web_practice_session_url(@practice_session),
                  notice: t('.success')
    end

    def update
      @practice_session = authorize PracticeSession.find(params[:id])

      if @practice_session.update(practice_session_update_params)
        redirect_to web_practice_session_url(@practice_session), notice: t('.success')
      else
        flash.now[:error] = "#{t('.failure')} #{@practice_session.errors.full_messages.join(', ')}"
        render :edit
      end
    end

    def destroy
      @practice_session = authorize PracticeSession.find(params[:id])

      @practice_session.destroy!
      redirect_to web_practice_sessions_url, notice: t('.success')
    end

    private

    def set_practice_session
      @practice_session = PracticeSession.find(params[:id])
    end

    def practice_session_params
      params
        .require(:practice_session)
        .permit(:music_id, :goals, :status)
    end

    def practice_session_update_params
      params
        .require(:practice_session)
        .permit(:goals, :status)
    end
  end
end
