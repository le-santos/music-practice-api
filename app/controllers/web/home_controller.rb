module Web
  class HomeController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]

    def index
      return unless user_signed_in?

      @musics_count = current_user.musics.count
      @practice_sessions_count = current_user.practice_sessions.count
      @recent_sessions = current_user.practice_sessions.order(created_at: :desc).limit(5)
    end
  end
end
