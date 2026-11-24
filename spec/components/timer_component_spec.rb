require 'rails_helper'

RSpec.describe TimerComponent, type: :component do
  include ViewComponent::TestHelpers

  let(:draft) { instance_double(Draft, timer_live?: true, active?: true, last_pick_at: Time.now, timer_minutes: 5) }
  let(:component) { described_class.new(draft: draft) }

  before { allow(component).to receive(:seconds_until_timer_end).and_return(3725) }

  it 'renders the remaining time on first paint' do
    render_inline(component)

    expect(rendered_content).to match(%r{<h1 class="timer-display"[^>]*>01:02:05</h1>})
  end
end
