require 'rails_helper'

RSpec.describe 'Users routes' do
  let(:headers) { { 'Authorization' => Rails.application.secret_key_base } }
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'POST #create' do
    let(:post_request) { post '/api/v1/register', params: params }
    let(:params) do
      { user: { username: 'Fulano', email: 'email@email', password: '123456' } }
    end

    it 'new user' do
      expect { post_request }.to change { User.count }.by(1)
      expect(response_json[:user_id]).to eq(User.last.id)
    end
  end
end
