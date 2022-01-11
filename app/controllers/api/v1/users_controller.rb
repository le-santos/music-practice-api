module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate, only: [:create]
      rescue_from ActionController::ParameterMissing, with: :missing_params

      def create
        user = User.new(user_params)
        payload = { user_id: user.id }

        if user.save
          create_token(payload)
          render status: :created, json: payload
        else
          render status: :unprocessable_entity,
                 json: user.errors.full_messages
        end
      end

      private

      def user_params
        params.permit(%i[username password email]).tap do |user|
          user.require(:username)
          user.require(:email)
          user.require(:password)
        end
      end

      def missing_params(error)
        render status: :unprocessable_entity,
               json: { error: error.original_message }
      end
    end
  end
end
