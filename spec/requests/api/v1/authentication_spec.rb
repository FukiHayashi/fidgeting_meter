require 'rails_helper'

RSpec.describe 'authentication', type: :request do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }
  describe 'Post /api/v1/authentication' do
    context '登録されたユーザ情報を送信した時' do
      let(:user_params) { { email: user.email, password: password }.to_json }
      it 'Jsonデータでユーザ情報を返すこと' do
        post api_v1_authentication_path, params: user_params, headers: { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json' }
        expect(status).to eq 200
        expect(body['data']['type']).to eq 'user'
        expect(body['data']['attributes']['name']).to eq user.name
        expect(body['data']['attributes']['email']).to eq user.email
        key = ApiKey.find_by(user: user).access_token
        expect(response.headers["AccessToken"]).to eq key
      end
    end

    context '未登録のユーザ情報を送信した時' do
      let(:user_params) { { email: 'no_registered_user@example.com', password: nil }.to_json }
      it 'Jsonデータでエラーを返すこと' do
        post api_v1_authentication_path, params: user_params, headers: { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json' }
        expect(status).to eq 404
        expect(body.dig('message')).to eq 'Record Not Found'
      end
    end
  end
end
