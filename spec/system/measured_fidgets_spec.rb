require 'rails_helper'

RSpec.describe 'MeasuredFidgets', type: :system do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }
  let!(:measured_fidgets) { create_list(:measured_fidget, 10, user: user) }
  let!(:another_user) { create(:user, password: password, password_confirmation: password) }
  let!(:another_measured_fidgets) { create_list(:measured_fidget, 5, user: another_user) }

  describe '一覧' do
    context 'ログインしたユーザの場合' do
      before { login(user.email, password) }
      it 'ユーザのmeasured_fidgetsが表示されること' do
        visit measured_fidgets_path

        expect(page.all(".measured_fidget").count).to eq measured_fidgets.count
      end
    end

    context 'ログインしていないユーザの場合' do
      it 'ログインページが表示されること' do
        visit measured_fidgets_path

        expect(current_path).to eq login_path
      end
    end
  end
end
