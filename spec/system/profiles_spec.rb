require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }

  describe 'ユーザ編集' do
    before do
      login(user.email, password)
      visit edit_profile_path
    end
    context '有効な情報が入力された場合' do
      it 'ユーザ情報が更新されること' do
        name = 'changed'
        email = 'changed@example.com'
        fill_in I18n.t('activerecord.attributes.user.name'), with: name
        fill_in I18n.t('activerecord.attributes.user.email'), with: email
        fill_in I18n.t('activerecord.attributes.user.password'), with: password
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: password
        check 'setting_push_notification'
        check 'setting_desktop_application_cooperation'
        click_on I18n.t('defaults.update')
        expect(current_path).to eq profile_path

        visit edit_profile_path
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
        fill_in I18n.t('activerecord.attributes.user.name'), with: nil
        fill_in I18n.t('activerecord.attributes.user.email'), with: nil
        fill_in I18n.t('activerecord.attributes.user.password'), with: nil
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: nil
        check 'setting_push_notification'
        check 'setting_desktop_application_cooperation'
        click_on I18n.t('defaults.update')

        visit edit_profile_path
        expect(user.setting.push_notification).to eq false
        expect(user.setting.desktop_application_cooperation).to eq false
        expect(user.name).to_not eq name
        expect(user.email).to_not eq email
      end
    end

    context '重複するメールアドレスが入力された場合' do
      let(:invalid_user) { create(:user, password: password, password_confirmation: password) }
      let(:invalid_user_setting) { create(:setting, user: invalid_user) }

      it '情報が更新されないこと' do
        fill_in I18n.t('activerecord.attributes.user.name'), with: invalid_user.name
        fill_in I18n.t('activerecord.attributes.user.email'), with: user.email
        fill_in I18n.t('activerecord.attributes.user.password'), with: password
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: password
        click_on I18n.t('defaults.update')

        visit edit_profile_path
        expect(invalid_user.email).to_not eq user.email
      end
    end
  end

  describe 'ユーザ削除' do
    context 'ユーザを削除した時' do
      before do
        login(user.email, password)
        visit edit_profile_path
      end
      it 'ユーザが削除されること' do
        user_count = User.count
        click_on I18n.t('defaults.delete')
        expect(User.count).to be < user_count
      end
    end
  end
end
