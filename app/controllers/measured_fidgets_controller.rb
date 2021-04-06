class MeasuredFidgetsController < ApplicationController
  def index
    @measured_fidgets = current_user.measured_fidgets
  end
end
