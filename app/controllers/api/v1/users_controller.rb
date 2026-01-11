module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate, only: %i[create login]
      before_action :check_params, only: :create

      def create
        user = User.new(permitted_params)

        if user.save
          render status: :created, json: { user_id: user.id }
        else
          render status: :unprocessable_entity,
                 json: user.errors.full_messages
        end
      end

      def login
        user = User.find_by(email: permitted_params[:email])

        if user&.valid_password?(permitted_params[:password])
          token = create_token(user.email)
          render status: :created, json: { id: user.id, token: token }
        else
          render status: :unprocessable_entity,
                 json: { error: 'Invalid User or Password' }
        end
      end

      private

      def permitted_params
        params.permit(:username, :password, :email)
      end

      def check_params
        return unless blank_values? || missing_keys?

        render status: :unprocessable_entity,
               json: { error: 'missing params' }
      end

      def blank_values?
        permitted_params.values.any?(&:blank?)
      end

      def missing_keys?
        user_params = %i[username password email]
        user_params.map(&:to_s) != permitted_params.keys
      end
    end
  end
end
