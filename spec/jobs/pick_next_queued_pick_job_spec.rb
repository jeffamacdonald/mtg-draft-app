require 'rails_helper'

RSpec.describe PickNextQueuedPickJob, type: :job do
  let!(:draft) { create :draft }
  let(:queue_active) { true }
  let!(:draft_participant) { create :draft_participant, draft:, queue_active: queue_active }
  let!(:next_drafter) { create :draft_participant, draft: }
  let(:cube_card) { nil }
  let!(:participant_pick) { create :participant_pick, draft_participant:, cube_card: cube_card, round: 1, pick_number: 1 }
  let!(:next_pick) { create :participant_pick, draft_participant: next_drafter, cube_card: nil, round: 1, pick_number: 2 }
  let(:queued_card_1) { create :cube_card }
  let(:queued_card_2) { create :cube_card }
  let!(:queued_pick_1) { create :queued_pick, draft_participant:, cube_card: queued_card_1, priority_number: 1 }
  let!(:queued_pick_2) { create :queued_pick, draft_participant:, cube_card: queued_card_2, priority_number: 2 }

  context "when active_pick is not participant_pick" do
    let(:cube_card) { create :cube_card }

    it "does nothing" do
      described_class.perform_now(participant_pick)

      expect(participant_pick.reload.cube_card).not_to eq queued_card_1
    end
  end

  context "when active_pick is participant_pick" do
    context "when queue is inactive" do
      let(:queue_active) { false }

      it "does nothing" do
        described_class.perform_now(participant_pick)

        expect(participant_pick.reload.cube_card).to be_nil
      end
    end

    context "when queue is active" do
      context "when queued_picks are not present" do
        let!(:queued_pick_1) { nil }
        let!(:queued_pick_2) { nil }

        it "does nothing" do
          described_class.perform_now(participant_pick)

          expect(participant_pick.reload.cube_card).to be_nil
        end
      end

      context "when queued picks are present" do
        it "picks the queued pick with priority 1" do
          described_class.perform_now(participant_pick)

          expect(participant_pick.reload.cube_card).to eq queued_card_1
        end
      end
    end
  end
end