require 'rails_helper'

RSpec.describe AuthenticationTokenService do
  describe '.call' do
    subject(:auth_token) { described_class.call(user.id) }

    let(:secret) { described_class::HMAC_SECRET }
    let(:algorithm) { described_class::ALGORITHM_TYPE }
    let(:user) { create(:user, username: 'user1', password: 'password') }
    let(:payload) {{ user_id: user.id }}
    let(:encoded_token) do
      JWT.encode(payload, secret, algorithm)
    end

    it 'returns a authentication token' do
      expect(auth_token).to eq(encoded_token)
    end
  end

  describe '.decode' do
    subject(:decode_token) { described_class.decode(encoded_token) }

    let(:secret) { described_class::HMAC_SECRET }
    let(:algorithm) { described_class::ALGORITHM_TYPE }
    let(:user) { create(:user, username: 'user1', password: 'password') }
    let(:payload) {{ user_id: user.id }}
    let(:encoded_token) do
      JWT.encode(payload, secret, algorithm)
    end
    let(:decoded_token_data) { [{'user_id' => 1}, {'alg' => 'HS256'}] }

    it 'returns decoded token data' do
      expect(decode_token).to eq(decoded_token_data)
    end
  end
end
