require 'rails_helper'

RSpec.describe Broadcast::DraftUpdateJob, type: :job do
	let!(:draft) { create :draft }
  let!(:dp1) { create :draft_participant, draft:, draft_position: 1 }
  let!(:dp2) { create :draft_participant, draft:, draft_position: 2 }
  let!(:dp3) { create :draft_participant, draft:, draft_position: 3 }

  it "performs turbo stream replace to each user" do
  	expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).exactly(3).times
  	described_class.perform_now(draft)
  end
end