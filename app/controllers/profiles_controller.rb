class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  def show
    @evaluation_fidgets = EvaluationFidgets.new(@user)
  end

  def edit; end

  def update
    if @user.update(update_user_params)
      redirect_to profile_path
    else
      render :edit
    end
  end

  def update_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, setting_attributes: %i[push_notification desktop_application_cooperation])
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
