# frozen_string_literal: true

class TimerComponent < ViewComponent::Base
  attr_reader :draft

  def initialize(draft:)
    @draft = draft
  end

  def render?
    draft.timer_live?
  end

  def seconds_until_timer_end
    timer_end.to_i - Time.now.to_i
  end

  def timer_end
    TimerCalculator.new(draft.last_pick_at, draft.timer_minutes).calculate_target_end
  end
end
