require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }
  before { login(user.email, password) }

  describe 'プロフィールページ' do
    let!(:measured_fidgets) { create_list(:measured_fidget, 10, user: user) }
    before { visit profile_path }

    context '自震情報をクリックした時' do
      it '一覧(measured_fidgets#show)ページに遷移すること' do
        find('.measured_fidgets_link').click
        expect(current_path).to eq measured_fidgets_path
      end
    end

    context 'ログアウトをクリックした時' do
      it 'ログインページに遷移すること' do
        find('#dropdownMenuButton').click
        find('.logout_link').click
        expect(current_path).to eq login_path
      end
    end

    context '設定をクリックした時' do
      it '設定(profile#edit)ページに遷移すること' do
        find('#dropdownMenuButton').click
        find('.edit_profile_link').click
        expect(current_path).to eq edit_profile_path
      end
    end

    context '１週間内で自震情報がある時' do
      before { @ef = EvaluationFidgets.new(user) }
      it 'グラフに累計時間が表示されること' do
        within('#js_weekly_fidget_times_chart') do
          expect(page).to have_content '累計時間'
          cnt = 0
          all('tspan').each do |tspan|
            cnt = cnt + 1 if tspan.text.to_f == @ef.fidget_times.last
          end
          expect(cnt).to eq 1
        end
      end
      it 'グラフにカロリーが表示されること' do
        within('#js_weekly_fidget_calories_chart') do
          expect(page).to have_content 'カロリー'
          cnt = 0
          all('tspan').each do |tspan|
            cnt = cnt + 1 if tspan.text.to_f == @ef.fidget_calories.last.round
          end
          expect(cnt).to eq 1
        end
      end
      it 'グラフに最大自震度が表示されること' do
        within('#js_weekly_fidget_levels_chart') do
          expect(page).to have_content '最大自震度'
          cnt = 0
          all('tspan').each do |tspan|
            cnt = cnt + 1 if tspan.text.to_f == @ef.fidget_level_maximums.last
          end
          expect(cnt).to eq 1
        end
      end
    end
  end

  describe 'ユーザ情報編集' do
    before { visit edit_profile_path }

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

  describe 'ユーザ情報削除' do

    context 'ユーザを削除した時' do
      before { visit edit_profile_path }
      it 'ユーザが削除されること' do
        user_count = User.count
        click_on I18n.t('defaults.delete')
        expect(User.count).to be < user_count
      end
    end
  end
end
