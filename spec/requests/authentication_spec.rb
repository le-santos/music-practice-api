require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /authenticate' do
    let(:user) { create(:user, username: 'user1', password: 'password') }
    let(:params_body) { { username: user.username, password: 'password' } }

    let(:secret) { AuthenticationTokenService::HMAC_SECRET }
    let(:algorithm) { AuthenticationTokenService::ALGORITHM_TYPE }
    let(:user) { create(:user, username: 'user1', password: 'password') }
    let(:payload) {{ user_id: user.id }}
    let(:encoded_token) do
      JWT.encode(payload, secret, algorithm)
    end

    it 'authenticates the user' do
      post '/api/v1/authenticate', params: params_body

      expect(response).to have_http_status(:created)
    end

    it 'returns user token' do
      post '/api/v1/authenticate', params: params_body

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to eq({ token: encoded_token })
    end

    it 'returns error when username is missing' do
      post '/api/v1/authenticate', params: { password: 'password' }

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response[:error]).to eq('param is missing or the value is empty: username')
    end

    it 'returns error when password is missing' do
      post '/api/v1/authenticate', params: { username: user.username }

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response[:error]).to eq('param is missing or the value is empty: password')
    end

    it 'returns error if user not not found' do
      post '/api/v1/authenticate', params: { username: 'not_existent_user', password: '123' }

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response[:error]).to eq('user does not exist')
    end
  end

  # ####
  # describe 'POST /login' do
  #   let(:user) { create(:user, username: 'user1', password: 'password') }

  #   it 'authenticates the user' do
  #     post '/api/v1/login', params: { username: user.username, password: 'password' }
  #     expect(response).to have_http_status(:created)
  #     expect(json).to eq({
  #                          'id' => user.id,
  #                          'username' => 'user1',
  #                          'token' => AuthenticationTokenService.call(user.id)
  #                        })
  #   end

  #   it 'returns error when username does not exist' do
  #     post '/api/v1/login', params: { username: 'ac', password: 'password' }
  #     expect(response).to have_http_status(:unauthorized)
  #     expect(json).to eq({
  #                          'error' => 'No such user'
  #                        })
  #   end

  #   it 'returns error when password is incorrect' do
  #     post '/api/v1/login', params: { username: user.username, password: 'incorrect' }
  #     expect(response).to have_http_status(:unauthorized)
  #     expect(json).to eq({
  #                          'error' => 'Incorrect password '
  #                        })
  #   end
  # end
end
