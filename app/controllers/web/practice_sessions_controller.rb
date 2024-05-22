module Web
  class PracticeSessionsController < ApplicationController
    def index
      @practice_sessions = PracticeSession.where(user: current_user)
    end

    def show
      @practice_session = authorize PracticeSession.find(params[:id])
    end
  end
end
