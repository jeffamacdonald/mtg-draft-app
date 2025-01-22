require 'rails_helper'

RSpec.describe SkipActiveParticipantJob, type: :job do
  let!(:draft) { create :draft }
  let!(:dp1) { create :draft_participant, draft:, draft_position: 1 }
  let!(:dp2) { create :draft_participant, draft:, draft_position: 2 }
  let!(:dp3) { create :draft_participant, draft:, draft_position: 3 }

  context "when active participant is not draft participant" do
    let!(:participant_pick_1) { create :participant_pick, draft_participant: dp1, pick_number: 1 }
    let!(:participant_pick_2) { create :participant_pick, draft_participant: dp2, pick_number: 2 }
    let!(:participant_pick_3) { create :participant_pick, draft_participant: dp3, pick_number: 3 }
    let!(:participant_pick_4) { create :participant_pick, draft_participant: dp3, pick_number: 4, round: 2 }

    it "does nothing" do
      expect {
        described_class.perform_now(draft.reload, dp3, 3)
      }.not_to change(dp3, :skipped)
    end
  end

  context "when active participant is draft participant" do
    let!(:participant_pick_1) { create :participant_pick, draft_participant: dp1, pick_number: 1 }
    let!(:participant_pick_2) { create :participant_pick, draft_participant: dp2, pick_number: 2 }
    let!(:participant_pick_3) { create :participant_pick, draft_participant: dp3, pick_number: 3 }
    let!(:participant_pick_4) { create :participant_pick, draft_participant: dp3, pick_number: 4, round: 2 }

    context "when draft last pick number equals last pick number" do
      it "skips drafter, updates draft last_pick_at, emails next active participant, broadcasts to draft channel, and enqueues the next skip job" do
        expect(PickMailer).to receive(:skipped_email).with(dp2, dp1.user).and_call_original
        expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now)
        expect(Broadcast::DraftUpdateJob).to receive(:perform_later).with(draft)
        expect(draft).to receive(:enqueue_skip_job).with(dp1)

        expect {
          described_class.perform_now(draft.reload, dp2, 4)
        }.to change(dp2, :skipped).to(true)
        .and change(draft, :last_pick_at)
      end

      context "when skipping last drafter in the round" do
        let!(:participant_pick_5) { create :participant_pick, draft_participant: dp2, pick_number: 5, round: 2 }

        it "increments draft active_round" do
          expect(PickMailer).to receive(:skipped_email).with(dp1, dp2.user).and_call_original
          expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now)
          expect(Broadcast::DraftUpdateJob).to receive(:perform_later).with(draft)
          expect(draft).to receive(:enqueue_skip_job).with(dp2)

          expect {
            described_class.perform_now(draft.reload, dp1, 5)
          }.to change(draft, :active_round).to(3)
        end
      end
    end

    context "when draft last pick number does not equal last pick number" do
      it "does nothing" do
        expect {
          described_class.perform_now(draft.reload, dp2, 1)
        }.not_to change(dp3, :skipped)
      end
    end
  end
end
