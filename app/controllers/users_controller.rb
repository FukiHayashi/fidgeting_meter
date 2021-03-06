class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.create_setting
      redirect_to login_path
    else
      render :new
    end
  end

  def destroy
    @user.destroy!

    redirect_to new_user_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
