class EvaluationFidgets
  @@evaluate_days = []
  @@comprehensive_evaluation
  @@frustration_levels = []
  @@fidget_level_maximums = []

  def initialize(user)
    (6.days.ago.to_datetime .. Date.today.to_datetime).each do |day|
      puts day.to_date
      fidget_levels = user.measured_fidgets.where(detected_at: day.all_day).pluck(:fidget_level)
      measured_times = user.measured_fidgets.where(detected_at: day.all_day).pluck(:measured_time)

      @@evaluate_days.push(day.to_date)
      if fidget_levels.count > 0 && measured_times.count == fidget_levels.count
        @@frustration_levels.push(calc_frustration_level(fidget_levels, measured_times))
        @@fidget_level_maximums.push(calc_maximum_fidget_level(fidget_levels))
      else
        @@frustration_levels.push(0)
        @@fidget_level_maximums.push(0)
      end
    end
    @@comprehensive_evaluation = calc_comprehensive_evaluation(@@frustration_levels, @@fidget_level_maximums)
  end

  def get_evaluate_days
    @@evaluate_days
  end

  def get_comprehensive_evaluation
    @@comprehensive_evaluation
  end

  def get_frustration_levels
    @@frustration_levels
  end

  def get_fidget_level_maximums
    @@fidget_level_maximums
  end

  private

  def calc_comprehensive_evaluation(frustration_levels, fidget_level_maximums)
    get_average(frustration_levels) * fidget_level_maximums.max
  end

  def calc_frustration_level(fidget_levels, measured_times)
    measured_time_average = get_average(measured_times)
    get_average(fidget_levels) / measured_time_average if measured_time_average > 0
  end

  def calc_maximum_fidget_level(fidget_levels)
    fidget_levels.max
  end

  def get_average(array)
    if array.length > 0
      array.sum / array.length
    else
      0
    end
  end

end
