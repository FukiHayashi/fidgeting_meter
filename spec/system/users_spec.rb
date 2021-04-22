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
        fill_in I18n.t('activerecord.attributes.user.name'), with: valid_user.name
        fill_in I18n.t('activerecord.attributes.user.email'), with: valid_user.email
        fill_in I18n.t('activerecord.attributes.user.password'), with: password
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: password
        click_on I18n.t('defaults.register')

        expect(User.find_by(name: valid_user.name).email).to eq valid_user.email
        expect(current_path).to eq login_path
      end
    end

    context '無効な情報が入力された場合' do
      let(:invalid_user){ build(:user, name: nil, email: nil, password: nil, password_confirmation: nil) }
      it 'エラーが表示されること' do
        fill_in I18n.t('activerecord.attributes.user.name'), with: invalid_user.name
        fill_in I18n.t('activerecord.attributes.user.email'), with: invalid_user.email
        fill_in I18n.t('activerecord.attributes.user.password'), with: nil
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: nil
        click_on I18n.t('defaults.register')

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
        fill_in I18n.t('activerecord.attributes.user.name'), with: invalid_user.name
        fill_in I18n.t('activerecord.attributes.user.email'), with: invalid_user.email
        fill_in I18n.t('activerecord.attributes.user.password'), with: password
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: password
        click_on I18n.t('defaults.register')

        invalid_user.valid?
        expect(invalid_user.errors.full_messages.count).to be > 0
        invalid_user.errors.full_messages.each do |message|
          expect(page).to have_content message
        end
      end
    end
  end
end
