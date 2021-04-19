require 'rails_helper'

RSpec.describe 'Authentications', type: :system do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }
  describe 'ログイン' do
    context 'ログイン情報が登録情報と一致する時' do
      it 'ログインできること' do
        login(user.email, password)

        expect(current_path).to eq profile_path
      end
    end
    context 'ログイン情報が登録情報と一致しない時' do
      it 'ログインできないこと' do
        login(nil, nil)

        expect(current_path).to eq login_path
      end
    end
  end
end
