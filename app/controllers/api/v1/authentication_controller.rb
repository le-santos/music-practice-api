module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :load_user, on: :create
      rescue_from ActionController::ParameterMissing, with: :missing_params

      def create
        token = AuthenticationTokenService.call(@user.id)

        render status: :created, json: { token: token }
      end

      private

      def filtered_params
        params.permit(%i[username password]).tap do |user_params|
          user_params.require(:username)
          user_params.require(:password)
        end
      end

      def missing_params(error)
        render status: :unprocessable_entity, json: { error: error.original_message }
      end

      def load_user
        username = filtered_params[:username]
        @user ||= User.find_by(username: username)

        render status: :unprocessable_entity,
          json: { error: 'user does not exist' } if @user.blank?
      end
    end
  end
end
