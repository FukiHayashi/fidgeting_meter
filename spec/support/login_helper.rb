module LoginHelper
  def login(email, password)
    visit login_path
    fill_in I18n.t('authentication.form.email'), with: email
    fill_in I18n.t('authentication.form.password'), with: password
    find_button(I18n.t('defaults.login')).click
  end
end
