require 'rails_helper'

RSpec.describe 'measured_fidgets', type: :request do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:api_key){ create(:api_key, user: user) }

  describe "POST api/v1/measured_fidgets" do
    let!(:measured_fidget) { build(:measured_fidget) }
    context "measured_fidgetモデルのjsonデータをPostした時" do
      let(:measured_fidget_params) { attributes_for(:measured_fidget) }
      it 'measured_fidgetが登録されること' do
        measured_fidget_count = MeasuredFidget.count
        post api_v1_measured_fidgets_path, params: measured_fidget_params.to_json, headers: { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json', Authorization: "Bearer #{api_key.access_token}" }
        expect(status).to eq 200
        expect(response.body).to eq ""
        expect(MeasuredFidget.count).to eq measured_fidget_count + 1
      end
    end

    context "measured_fidgetモデルではないjsonデータをPostした時" do
      let(:user_params) { attributes_for(:user) }
      it '500が返されること' do
        measured_fidget_count = MeasuredFidget.count
        post api_v1_measured_fidgets_path, params: user_params.to_json, headers: { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json', Authorization: "Bearer #{api_key.access_token}" }
        expect(status).to eq 500
      end
    end

    context "api_keyなしでjsonデータをPostした時" do
      let(:measured_fidget_params) { attributes_for(:measured_fidget) }
      it '401が返されること' do
        measured_fidget_count = MeasuredFidget.count
        post api_v1_measured_fidgets_path, params: measured_fidget_params.to_json, headers: { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json' }
        expect(status).to eq 401
      end
    end
  end
end
