require 'rails_helper'

RSpec.describe AuthenticationTokenService do
  describe '.encode' do
    subject(:auth_token) { described_class.encode(user.email) }

    let(:secret) { described_class::HMAC_SECRET }
    let(:algorithm) { described_class::ALGORITHM_TYPE }
    let(:user) { create(:user, username: 'user1', password: '123456qwerty') }
    let(:payload) { { email: user.email, exp: 1.hour.from_now.to_i } }
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
    let(:user) { create(:user, email: 'user@email.com') }
    let(:payload) { { email: user.email, exp: 1.hour.from_now.to_i } }
    let(:encoded_token) do
      JWT.encode(payload, secret, algorithm)
    end

    it 'returns decoded token data' do
      expect(decode_token[0]['email']).to eq(user.email)
    end

    context 'when token has expired' do
      it 'returns nil' do
        Timecop.travel(2.hours.ago) do
          encoded_token
        end

        expect(decode_token).to be_nil
      end
    end
  end
end
