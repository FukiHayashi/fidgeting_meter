require 'rails_helper'

RSpec.describe 'Authentications', type: :system do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }
  describe 'ログイン' do
    before { visit login_path }
    context 'ログイン情報が登録情報と一致する時' do
      it 'ログインできること' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: password
        click_on 'login'

        expect(current_path).to eq user_path(user)
      end
    end
    context 'ログイン情報が登録情報と一致しない時' do
      it 'ログインできないこと' do
        fill_in 'Email', with: nil
        fill_in 'Password', with: nil

        expect(current_path).to eq login_path
      end
    end
  end
end
