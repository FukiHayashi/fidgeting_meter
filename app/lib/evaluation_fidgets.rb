class EvaluationFidgets
  attr_accessor :evaluate_days, :comprehensive_evaluation, :fidget_times, :fidget_level_maximums, :fidget_calories

  def initialize(user)
    @evaluate_days = []
    @fidget_times = []
    @fidget_calories = []
    @fidget_level_maximums = []
    (6.days.ago.to_datetime..Date.today.to_datetime).each do |day|
      fidget_levels = user.measured_fidgets.where(detected_at: day.all_day).pluck(:fidget_level)
      measured_times = user.measured_fidgets.where(detected_at: day.all_day).pluck(:measured_time)
      set_evaluate(day, measured_times, fidget_levels)
    end
    @comprehensive_evaluation = calc_comprehensive_evaluation
  end

  private

  def set_evaluate(day, measured_times, fidget_levels)
    @evaluate_days.push(day.to_date)
    if fidget_levels.count.positive? && measured_times.count == fidget_levels.count
      @fidget_times.push(measured_times.sum)
      @fidget_level_maximums.push(calc_maximum_fidget_level(fidget_levels))
      @fidget_calories.push(measured_times.sum / 3_600 * 40_000)
    else
      @fidget_times.push(0)
      @fidget_level_maximums.push(0)
      @fidget_calories.push(0)
    end
  end

  def calc_comprehensive_evaluation
    0
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
