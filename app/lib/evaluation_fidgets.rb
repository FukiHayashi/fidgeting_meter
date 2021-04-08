class EvaluationFidgets
  attr_accessor :evaluate_days, :comprehensive_evaluation, :frustration_levels, :fidget_level_maximums

  def initialize(user)
    @evaluate_days = []
    @frustration_levels = []
    @fidget_level_maximums = []
    (6.days.ago.to_datetime..Date.today.to_datetime).each do |day|
      puts day.to_date
      fidget_levels = user.measured_fidgets.where(detected_at: day.all_day).pluck(:fidget_level)
      measured_times = user.measured_fidgets.where(detected_at: day.all_day).pluck(:measured_time)
      set_evaluate(day, measured_times, fidget_levels)
    end
    @comprehensive_evaluation = calc_comprehensive_evaluation(@frustration_levels, @fidget_level_maximums)
  end

  private

  def set_evaluate(day, measured_times, fidget_levels)
    @evaluate_days.push(day.to_date)
    if fidget_levels.count.positive? && measured_times.count == fidget_levels.count
      @frustration_levels.push(calc_frustration_level(fidget_levels, measured_times))
      @fidget_level_maximums.push(calc_maximum_fidget_level(fidget_levels))
    else
      @frustration_levels.push(0)
      @fidget_level_maximums.push(0)
    end
  end

  def calc_comprehensive_evaluation(frustration_levels, fidget_level_maximums)
    average(frustration_levels) * fidget_level_maximums.max
  end

  def calc_frustration_level(fidget_levels, measured_times)
    measured_time_average = average(measured_times)
    average(fidget_levels) / measured_time_average if measured_time_average.positive?
  end

  def calc_maximum_fidget_level(fidget_levels)
    fidget_levels.max
  end

  def average(array)
    if array.length.positive?
      array.sum / array.length
    else
      0
    end
  end
end
