class AuthenticationController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to user_path(@user)
    else
      redirect_to login_path
    end
  end

  def destory
    logout
    redirect_to new_user_path
  end
end
