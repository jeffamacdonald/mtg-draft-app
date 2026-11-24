# frozen_string_literal: true

class TimerComponent < ViewComponent::Base
  attr_reader :draft

  def initialize(draft:)
    @draft = draft
  end

  def render?
    draft.timer_live? && draft.active?
  end

  # Same format as countdown_controller.js, so the first paint already shows the time.
  def initial_time_text
    days, remainder = [seconds_until_timer_end, 0].max.divmod(86_400)
    hours, remainder = remainder.divmod(3600)
    minutes, seconds = remainder.divmod(60)
    clock = Kernel.format("%02d:%02d:%02d", hours, minutes, seconds)

    case days
    when 0 then clock
    when 1 then "1 day #{clock}"
    else "#{days} days #{clock}"
    end
  end

  def seconds_until_timer_end
    timer_end.to_i - Time.now.to_i
  end

  def timer_end
    TimerCalculator.new(draft.last_pick_at, draft.timer_minutes).calculate_target_end
  end
end
