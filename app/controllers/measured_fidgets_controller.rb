class MeasuredFidgetsController < ApplicationController
  before_action :set_user, only: %i[index]
  def index
    @measured_fidgets = current_user.measured_fidgets
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end
end
