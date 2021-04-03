require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }
  describe 'ユーザ登録' do
    before{ visit new_user_path }

    context '有効な情報が入力された場合' do
      let(:valid_user){ build(:user) }
      it 'ユーザ登録されること' do
        fill_in 'Name', with: valid_user.name
        fill_in 'Email', with: valid_user.email
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_on 'registration'

        expect(page).to have_content valid_user.name
      end
    end

    context '無効な情報が入力された場合' do
      let(:invalid_user){ build(:user, name: nil, email: nil, password: nil, password_confirmation: nil) }
      it 'エラーが表示されること' do
        fill_in 'Name', with: invalid_user.name
        fill_in 'Email', with: invalid_user.email
        fill_in 'Password', with: nil
        fill_in 'Password confirmation', with: nil
        click_on 'registration'

        invalid_user.valid?
        expect(invalid_user.errors.full_messages.count).to be > 0
        invalid_user.errors.full_messages.each do |message|
          expect(page).to have_content message
        end
      end
    end

    context '重複するメールアドレスが入力された場合' do
      let(:invalid_user){ build(:user, name: user.name, email: user.email, password: password, password_confirmation: password) }
      it 'エラーが表示されること' do
        fill_in 'Name', with: invalid_user.name
        fill_in 'Email', with: invalid_user.email
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_on 'registration'

        invalid_user.valid?
        expect(invalid_user.errors.full_messages.count).to be > 0
        invalid_user.errors.full_messages.each do |message|
          expect(page).to have_content message
        end
      end
    end
  end

  describe 'ユーザ編集' do
    before { visit edit_user_path(user) }
    context '有効な情報が入力された場合' do
      it 'ユーザ情報が更新されること' do
        name = 'changed'
        email = 'changed@example.com'
        fill_in 'Name', with: name
        fill_in 'Email', with: email
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        check 'setting_push_notification'
        check 'setting_desktop_application_cooperation'
        click_on 'registration'

        expect(find_by_id('setting_push_notification').checked?).to eq true
        expect(find_by_id('setting_desktop_application_cooperation').checked?).to eq true
        expect(find_by_id('user_name').value).to match name
        expect(find_by_id('user_email').value).to match email
      end
    end

    context '無効な情報が入力された場合' do
      it 'ユーザ情報が更新されないこと' do
        name = 'changed'
        email = 'changed@example.com'
        fill_in 'Name', with: nil
        fill_in 'Email', with: nil
        fill_in 'Password', with: nil
        fill_in 'Password confirmation', with: nil
        check 'setting_push_notification'
        check 'setting_desktop_application_cooperation'
        click_on 'registration'

        expect(user.setting.push_notification).to eq false
        expect(user.setting.desktop_application_cooperation).to eq false
        expect(user.name).to_not eq name
        expect(user.email).to_not eq email
      end
    end

    context '重複するメールアドレスが入力された場合' do
      let(:invalid_user) { create(:user, password: password, password_confirmation: password) }
      let(:invalid_user_setting) { create(:setting, user: invalid_user) }
      before { visit edit_user_path(invalid_user) }
      it '情報が更新されないこと' do
        fill_in 'Name', with: invalid_user.name
        fill_in 'Email', with: user.email
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_on 'registration'

        expect(invalid_user.email).to_not eq user.email
      end
    end
  end

  describe 'ユーザ削除' do
    context 'ユーザを削除した時' do
      before { visit edit_user_path(user) }
      it 'ユーザが削除されること' do
        user_count = User.count
        click_on 'delete'
        expect(User.count).to be < user_count 
      end
    end
  end
end
