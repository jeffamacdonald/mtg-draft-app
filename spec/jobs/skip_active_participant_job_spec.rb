require 'rails_helper'

RSpec.describe SkipActiveParticipantJob, type: :job do
  let!(:draft) { create :draft }
  let!(:dp1) { create :draft_participant, draft:, draft_position: 1 }
  let!(:dp2) { create :draft_participant, draft:, draft_position: 2 }
  let!(:dp3) { create :draft_participant, draft:, draft_position: 3 }

  context "when participant_pick is not active pick" do
    let!(:participant_pick_1) { create :participant_pick, draft_participant: dp1, pick_number: 1 }
    let!(:participant_pick_2) { create :participant_pick, draft_participant: dp2, pick_number: 2 }
    let!(:participant_pick_3) { create :participant_pick, draft_participant: dp3, pick_number: 3 }
    let!(:participant_pick_4) { create :participant_pick, draft_participant: dp3, pick_number: 4, round: 2 }

    it "does nothing" do
      expect {
        described_class.perform_now(participant_pick_1)
      }.not_to change(dp3, :skipped)
    end
  end

  context "when participant_pick is active pick" do
    let!(:participant_pick_1) { create :participant_pick, draft_participant: dp1, pick_number: 1 }
    let!(:participant_pick_2) { create :participant_pick, draft_participant: dp2, pick_number: 2 }
    let!(:participant_pick_3) { create :participant_pick, draft_participant: dp3, pick_number: 3 }
    let!(:participant_pick_4) { create :participant_pick, draft_participant: dp3, pick_number: 4, round: 2 }
    let!(:participant_pick_5) { create :participant_pick, cube_card_id: nil, draft_participant: dp2, pick_number: 5, round: 2 }
    let!(:participant_pick_6) { create :participant_pick, cube_card_id: nil, draft_participant: dp1, pick_number: 6, round: 2 }

    it "skips pick, skips drafter, updates draft last_pick_at, emails next active participant, broadcasts to draft channel, and enqueues the next skip job" do
      expect(PickMailer).to receive(:skipped_email).with(dp2, dp1.user).and_call_original
      expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now)
      expect(Broadcast::DraftUpdateJob).to receive(:perform_later).with(draft)
      expect(draft).to receive(:enqueue_skip_job)
      expect_any_instance_of(ParticipantPick).to receive(:enqueue_auto_pick_job)
      allow(participant_pick_5).to receive(:draft_participant).and_return(dp2)
      allow(participant_pick_5).to receive(:draft).and_return(draft)

      expect {
        described_class.perform_now(participant_pick_5)
      }.to change(dp2, :skipped).to(true)
      .and change(participant_pick_5, :skipped).to(true)
      .and change(draft, :last_pick_at)
    end

    context "when skipping last drafter in the round" do
      let!(:participant_pick_5) { create :participant_pick, draft_participant: dp2, pick_number: 5, round: 2 }
      let!(:participant_pick_6) { create :participant_pick, cube_card_id: nil, draft_participant: dp1, pick_number: 6, round: 2 }
      let!(:participant_pick_7) { create :participant_pick, cube_card_id: nil, draft_participant: dp1, pick_number: 7, round: 3 }

      it "does not email the user" do
        expect(PickMailer).not_to receive(:skipped_email)
        expect(Broadcast::DraftUpdateJob).to receive(:perform_later).with(draft)
        expect(draft).to receive(:enqueue_skip_job)
        allow(participant_pick_6).to receive(:draft).and_return(draft)

        described_class.perform_now(participant_pick_6)
      end
    end
  end
end
