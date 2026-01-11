module Web
  class PracticeSessionsController < ApplicationController
    def index
      practice_sessions = policy_scope(PracticeSession)
      @presenter = PracticeSessionsPresenter.new(practice_sessions)
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
      @practice_session = current_user.practice_sessions.new(practice_session_params)
      authorize @practice_session

      if @practice_session.save
        redirect_to web_practice_session_url(@practice_session), notice: t('.success')
      else
        @musics = current_user.musics.pluck(:title, :id)
        flash.now[:error] = format_errors(@practice_session)
        render :new
      end
    end

    def update
      @practice_session = authorize PracticeSession.find(params[:id])

      if @practice_session.update(practice_session_update_params)
        redirect_to web_practice_session_url(@practice_session), notice: t('.success')
      else
        @musics = current_user.musics.pluck(:title, :id)
        flash.now[:error] = format_errors(@practice_session)
        render :edit
      end
    end

    def destroy
      @practice_session = authorize PracticeSession.find(params[:id])

      @practice_session.destroy!
      redirect_to web_practice_sessions_url, notice: t('.success')
    end

    private

    def format_errors(record)
      "#{t('.failure')} #{record.errors.full_messages.join(', ')}"
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
