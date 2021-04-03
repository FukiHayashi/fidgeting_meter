class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.create_setting
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def delete
    @user.destroy!

    redirect_to new_user_path
  end

  def show; end

  def edit; end

  def update
    authorize(@user)

    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
