require 'rails_helper'

RSpec.describe 'Users routes' do
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'POST #create' do
    let(:post_request) { post '/api/v1/register', params: params }
    let(:params) do
      { username: 'Fulano', email: 'email@email', password: '123456qwerty' }
    end

    it 'register new user' do
      expect { post_request }.to change { User.count }.by(1)
    end

    it 'returns user id' do
      post_request

      expect(response_json[:user_id]).to eq(User.last.id)
    end

    context 'when params are missing' do
      let(:params) do
        { username: 'Fulano', email: 'email@email' }
      end

      it 'return status 422' do
        post_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return error messages' do
        post_request

        expect(response_json[:error]).to eq('missing params')
      end

      it 'does not register new user' do
        expect { post_request }.not_to change(User, :count)
      end
    end

    context 'when params are blank' do
      let(:params) do
        { username: 'Fulano', email: '', password: '' }
      end

      it 'return status 422' do
        post_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return error messages' do
        post_request

        expect(response_json[:error]).to eq('missing params')
      end

      it 'does not register new user' do
        expect { post_request }.not_to change(User, :count)
      end
    end
  end

  context 'POST #login' do
    let(:user) { create(:user, username: 'user1', password: '123456qwerty') }
    let(:user_token) { AuthenticationTokenService.encode(user.email) }
    let(:params) { { email: user.email, password: user.password } }
    let(:login_request) { post '/api/v1/login', params: params }

    it 'login user successfully' do
      login_request

      expect(response).to have_http_status(:created)
    end

    it 'return user_id and token' do
      login_request

      expect(response_json[:id]).to eq(user.id)
      expect(response_json[:token]).to eq(user_token)
    end

    context 'when invalid password' do
      let(:params) { { email: user.email, password: 'incorrect' } }

      it 'returns status 422' do
        login_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        login_request

        expect(response_json[:error]).to eq('Invalid User or Password')
      end
    end

    context 'when user does not exist' do
      let(:params) { { email: 'invalid@email', password: user.password } }

      it 'returns status 422' do
        login_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        login_request

        expect(response_json[:error]).to eq('Invalid User or Password')
      end
    end
  end
end
