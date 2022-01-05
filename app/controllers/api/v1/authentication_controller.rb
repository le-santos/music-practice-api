module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :check_params, on: :create
      rescue_from ActionController::ParameterMissing, with: :missing_params

      def create
        render status: :created, json: { token: '123' }
      end

      private

      def check_params
        params.require(%i[username password])
      end

      def missing_params(error)
        render status: :unprocessable_entity, json: { error: error.original_message }
      end
    end
  end
end
