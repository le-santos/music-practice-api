module Api
  module V1
    class ApiController < ActionController::API
      before_action :authenticate

      private

      def secret
        @secret = ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base
      end

      def create_token(user_id)
        AuthenticationTokenService.call(user_id)
      end

      def auth_header
        # "Bearer <token>"
        request.authorization
      end

      def decoded_token
        if auth_header
          token = auth_header.split.second
          begin
            AuthenticationTokenService.decode(token)
          rescue JWT::DecodeError
            nil
          end
        end
      end

      def logged_in_user
        if decoded_token
          user_id = decoded_token[0]['user_id']
          @user ||= User.find_by(id: user_id)
        end
      end

      def logged_in?
        !!logged_in_user
      end

      def authenticate
        unless logged_in?
          render json: { message: 'Please log in' },
                 status: :unauthorized
        end
      end
    end
  end
end
