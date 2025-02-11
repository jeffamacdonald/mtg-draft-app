require 'rails_helper'

RSpec.describe RemoveQueuedPicksJob, type: :job do
  let!(:draft) { create :draft }
  let!(:draft_participant_1) { create :draft_participant, draft: }
  let!(:draft_participant_2) { create :draft_participant, draft: }
  let!(:draft_participant_3) { create :draft_participant, draft:, queue_active: false }
  let!(:draft_participant_4) { create :draft_participant, draft: }
  let!(:cube_card) { create :cube_card }
  let!(:participant_pick) { create :participant_pick, draft_participant: draft_participant_1, cube_card: cube_card, round: 1, pick_number: 1 }
  let(:other_queued_card) { create :cube_card }
  let!(:queued_pick_1) { create :queued_pick, draft_participant: draft_participant_1, cube_card: cube_card, priority_number: 1 }
  let!(:queued_pick_2) { create :queued_pick, draft_participant: draft_participant_1, cube_card: other_queued_card, priority_number: 2 }
  let!(:queued_pick_3) { create :queued_pick, draft_participant: draft_participant_2, cube_card: cube_card, priority_number: 1 }
  let!(:queued_pick_4) { create :queued_pick, draft_participant: draft_participant_3, cube_card: cube_card, priority_number: 1}
  let!(:queued_pick_5) { create :queued_pick, draft_participant: draft_participant_4, cube_card: other_queued_card, priority_number: 1}

  it "deletes queued_picks that match the cube_card" do
    expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now)

    described_class.perform_now(participant_pick)

    expect(queued_pick_2.reload.priority_number).to eq 1
    expect(draft_participant_1.queued_picks.count).to eq 1
    expect(draft_participant_2.queued_picks.count).to eq 0
    expect(draft_participant_3.queued_picks.count).to eq 0
    expect(draft_participant_4.queued_picks.count).to eq 1

  end

  it "sets queue to inactive and emails drafters who had their upcoming pick taken" do
    expect(PickMailer).to receive(:queued_pick_taken_email).with(participant_pick, draft_participant_2.user).and_call_original
    expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now)
    expect(PickMailer).not_to receive(:queued_pick_taken_email).with(participant_pick, draft_participant_3.user)

    described_class.perform_now(participant_pick)
  end
end