module Api
  module V1
    class ApiController < ActionController::API
      before_action :authenticate

      private

      def secret
        @secret = ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base
      end

      def create_token(user_id)
        AuthenticationTokenService.encode(user_id)
      end

      def auth_header
        # "Bearer <token>"
        request.authorization
      end

      def decoded_token
        return unless auth_header

        token = auth_header.split.second
        AuthenticationTokenService.decode(token)
      rescue JWT::DecodeError
        nil
      end

      def logged_in_user
        return unless decoded_token

        user_email = decoded_token[0]['email']
        @logged_in_user ||= User.find_by(email: user_email)
      end

      def logged_in?
        !!logged_in_user
      end

      def authenticate
        return if logged_in?

        render json: { message: 'Please log in' },
               status: :unauthorized
      end
    end
  end
end
