module LoginHelper
  def login(email, password)
    visit login_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on I18n.t('defaults.login')
  end
end
