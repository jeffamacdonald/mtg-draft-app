require 'rails_helper'

# The main skip behavior is covered by spec/jobs/skip_active_participant_job_spec.rb
RSpec.describe Drafts::SkipActivePick do
  let(:draft) { create :draft, rounds: 1, status: DraftStatus.active }
  let(:draft_participant) { create :draft_participant, draft: }
  let!(:active_pick) { create :participant_pick, draft_participant:, cube_card: nil, pick_number: 1 }

  it "skips the final pick without emailing or failing for lack of a next pick" do
    expect(PickMailer).not_to receive(:skipped_email)
    expect(Broadcast::DraftUpdateJob).to receive(:perform_later)

    described_class.call(participant_pick: active_pick)

    expect(active_pick.reload.skipped).to eq true
    expect(draft_participant.reload.skipped).to eq true
  end

  context "when the skipped email fails to send" do
    let(:draft) { create :draft, rounds: 2, status: DraftStatus.active }
    let(:next_drafter) { create :draft_participant, draft: }
    let!(:next_pick) { create :participant_pick, draft_participant: next_drafter, cube_card: nil, pick_number: 2 }

    it "still broadcasts and enqueues the next turn" do
      allow(PickMailer).to receive(:skipped_email).and_raise(StandardError, "mail down")
      expect(Broadcast::DraftUpdateJob).to receive(:perform_later)
      expect(draft).to receive(:enqueue_skip_job)
      expect_any_instance_of(ParticipantPick).to receive(:enqueue_auto_pick_job)
      allow(active_pick).to receive(:draft).and_return(draft)
      draft.reload

      described_class.call(participant_pick: active_pick)

      expect(active_pick.reload.skipped).to eq true
    end
  end
end
