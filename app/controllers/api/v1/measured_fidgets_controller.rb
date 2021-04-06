class Api::V1::MeasuredFidgetsController < Api::V1::BaseController
  def create
    measured_fidget = @_current_user.measured_fidgets.build(measured_fidget_params)
    if measured_fidget.save
      head :ok
    else
      render_bad_request nil, measured_fidget.errors.full_messages
    end
  end

  private

  def measured_fidget_params
    params.require(:measured_fidget).permit(:detected_at, :fidget_level, :measured_time)
  end
end
