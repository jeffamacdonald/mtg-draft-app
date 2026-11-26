require 'rails_helper'

# The main skip behavior is covered by spec/jobs/skip_active_participant_job_spec.rb
RSpec.describe Drafts::SkipActivePick do
  let(:draft) { create :draft, rounds: 1, status: DraftStatus.active }
  let(:draft_participant) { create :draft_participant, draft: }
  let!(:final_pick) { create :participant_pick, draft_participant:, cube_card: nil, pick_number: 1 }

  it "skips the final pick without emailing or failing for lack of a next pick" do
    expect(PickMailer).not_to receive(:skipped_email)
    expect(Broadcast::DraftUpdateJob).to receive(:perform_later)

    described_class.call(participant_pick: final_pick)

    expect(final_pick.reload.skipped).to eq true
    expect(draft_participant.reload.skipped).to eq true
  end
end
