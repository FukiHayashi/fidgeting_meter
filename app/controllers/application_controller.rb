class ApplicationController < ActionController::Base
  before_action :require_login #sorceryが作成するメソッド。ログインしてない時not_authenticatedメソッドを発火する

  protected

  def not_authenticated
    redirect_to login_url
  end
end
