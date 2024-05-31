class TimerCalculator
  attr_reader :pick_time, :timer_minutes

  def initialize(pick_time, timer_minutes)
    @pick_time = pick_time.in_time_zone("Pacific Time (US & Canada)")
    @timer_minutes = timer_minutes
  end

  def calculate_target_end
    if pick_on_day_off? || extra_seconds.negative?
      start_plus_minutes
    else
      next_available_start_time + extra_seconds.seconds
    end
  end

  private

  def timer_start
    # Can only match first two conditions if today is not day_off?
    if first_date_time_on_the_clock.hour < 9
      today_start_time
    elsif first_date_time_on_the_clock.hour > 16
      next_available_start_time
    else
      first_date_time_on_the_clock
    end
  end

  def today_start_time
    start_of_day + 9.hours
  end

  def day_end_time
    timer_start.beginning_of_day + 17.hours
  end

  def start_of_day
    Time.zone.now.in_time_zone("Pacific Time (US & Canada)").beginning_of_day
  end

  def start_plus_minutes
    @_start_plus_minutes ||= timer_start + timer_minutes.minutes
  end

  def extra_seconds
    (start_plus_minutes - day_end_time).to_i
  end

  def pick_on_day_off?
    first_date_time_on_the_clock != pick_time
  end

  def first_date_time_on_the_clock
    @_first_date_time_on_the_clock ||= next_date_time_available
  end

  def day_off?(date_time)
    weekend?(date_time) || Holidays.on(date_time, :us_ca, :observed).present?
  end

  def weekend?(date_time)
    date_time.wday == 0 || date_time.wday == 6
  end

  def next_date_time_available
    date_time = pick_time
    while day_off?(date_time)
      # Set to next day at 9am
      date_time = (date_time + 1.day).beginning_of_day + 9.hours
    end
    date_time
  end

  def next_available_start_time
    date_time = start_of_day + 33.hours
    while day_off?(date_time)
      date_time += 1.day
    end
    date_time
  end
end
