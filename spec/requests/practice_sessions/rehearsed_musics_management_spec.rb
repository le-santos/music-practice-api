require 'rails_helper'

describe 'Rehearsed_music routes' do
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:user) { create(:user, username: 'user1', password: 'password') }
  let(:token) { AuthenticationTokenService.encode(user.email) }
  let(:response_json) { JSON.parse(response.body, symbolize_names: true) }

  context 'GET #index' do
    it 'return status ok' do
      practice_session = create(:practice_session, user:)
      create(:rehearsed_music, practice_session:)

      get("/api/v1/practice_sessions/#{practice_session.id}/rehearsed_musics", headers:)

      expect(response).to have_http_status(:ok)
    end

    it 'returns list of Rehearsed_musics in a practice_session' do
      practice_session = create(:practice_session, user:)
      music = create(:music, user:)
      create(:rehearsed_music, practice_session:, music:)

      get("/api/v1/practice_sessions/#{practice_session.id}/rehearsed_musics", headers:)

      expect(response_json.size).to eq(1)
      expect(response_json).to include(music.as_json.deep_symbolize_keys)
    end

    it 'returns empty array if no resource' do
      practice_session = create(:practice_session, user:)

      get("/api/v1/practice_sessions/#{practice_session.id}/rehearsed_musics", headers:)

      expect(response).to have_http_status(:ok)
      expect(response_json.size).to eq(0)
    end

    it 'return not found when practice session does not exist' do
      invalid_id = '123'
      get("/api/v1/practice_sessions/#{invalid_id}/rehearsed_musics", headers:)

      expect(response).to have_http_status(:not_found)
    end
  end
end
