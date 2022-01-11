require 'rails_helper'

RSpec.describe 'Users routes' do
  let(:headers) { { 'Authorization' => Rails.application.secret_key_base } }
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'POST #create' do
    let(:post_request) { post '/api/v1/register', params: params }
    let(:params) do
      { username: 'Fulano', email: 'email@email', password: '123456' }
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
        { username: 'Fulano', email: 'email@email', password: '' }
      end

      it 'return error messages' do
        post_request

        expect(response_json[:error]).
          to eq('param is missing or the value is empty: password')
      end

      it 'does not register new user' do
        expect { post_request }.not_to change { User.count }
      end
    end
  end
end
