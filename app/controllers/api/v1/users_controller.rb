module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate, only: [:create]

      def create
        user = User.new(user_params)

        if user.save
          payload = { user_id: user.id }
          create_token(payload)
          render status: :created, json: payload
        else
          render status: :unprocessable_entity,
                 json: user.errors.full_messages
        end
      end

      private

      def user_params
        params.require(:user).permit(:username,
                                     :email,
                                     :password)
      end
    end
  end
end
