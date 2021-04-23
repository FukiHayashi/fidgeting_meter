class MeasuredFidgetsController < ApplicationController
  before_action :set_user, only: %i[index]
  def index
    @measured_fidgets = @user.measured_fidgets.page(params[:page]).per(10)
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end
end
