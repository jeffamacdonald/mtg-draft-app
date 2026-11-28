require 'rails_helper'

RSpec.describe Drafts::MakePick do
  describe '.call' do
    let(:cube) { create :cube }
    let(:draft) { create :draft, cube: cube }
    let(:cube_card) { create :cube_card, cube: cube }
    let!(:participant_1) { create :draft_participant, draft: draft, draft_position: 1 }
    let!(:other_participants) do
      12.times { |i| create :draft_participant, draft: draft, draft_position: i+2 }
    end
    let!(:participant_14) { create :draft_participant, draft: draft, draft_position: 14 }

    let(:participant_pick_id) { participant_1.next_open_pick&.id }

    subject { described_class.call(draft_participant: participant_1, cube_card:, participant_pick_id:) }

    context 'when no cards are picked yet' do
      let!(:participant_pick_1) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: 1, pick_number: 1 }
      let!(:participant_pick_2) { create :participant_pick, draft_participant: participant_14, cube_card_id: nil, round: 1, pick_number: 2 }

      it 'updates active pick, updates last pick at, enqueues skip job, and broadcasts updates' do
        allow(participant_1).to receive(:draft).and_return(draft)
        expect(draft).to receive(:enqueue_skip_job)
        allow(draft).to receive(:active_pick).and_return(participant_pick_1, participant_pick_2)
        expect(participant_pick_2).to receive(:enqueue_auto_pick_job)
        expect(RemoveQueuedPicksJob).to receive(:perform_later).with(participant_pick_1)
        expect(Broadcast::DraftUpdateJob).to receive(:perform_later).with(draft)

        subject

        expect(participant_pick_1.reload.cube_card).to eq cube_card
        expect(draft.reload.last_pick_at).to eq participant_pick_1.updated_at
      end
    end

    context "when it is the last pick" do
      let!(:old_participant_pick) { create :participant_pick, draft_participant: participant_1, round: draft.rounds - 1, pick_number: 1 }
      let!(:participant_pick) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: draft.rounds, pick_number: draft.rounds * 14 }

      before { draft.update!(last_pick_number: participant_pick.pick_number - 1) }

      it "does not enqueue a skip job and completes the draft" do
        allow(participant_1).to receive(:draft).and_return(draft)
        expect(draft).not_to receive(:enqueue_skip_job)
        expect(SkipActiveParticipantJob).not_to receive(:set)

        subject

        expect(participant_pick.reload.cube_card).to eq cube_card
        expect(draft.reload.status).to eq DraftStatus.completed
      end
    end

    context 'when participant is skipped' do
      let!(:participant_1) { create :draft_participant, draft: draft, draft_position: 1, skipped: true }
      let!(:participant_pick_1) do
        create :participant_pick,
        draft_participant_id: participant_1.id,
        cube_card_id: nil,
        round: 1,
        pick_number: 1,
        skipped: true
      end

      it 'after pick participant is no longer skipped' do
        subject

        expect(participant_pick_1.reload.cube_card).to eq cube_card
        expect(participant_pick_1.skipped).to eq false
        expect(participant_1.skipped?).to be false
      end

      context 'when participant is behind multiple picks' do
        let!(:participant_pick_2) do
          create :participant_pick,
          draft_participant_id: participant_1.id,
          cube_card_id: nil,
          round: 2,
          pick_number: 28,
          skipped: true
        end
        let!(:participant_pick_3) do
          create :participant_pick,
          draft_participant_id: participant_14.id,
          round: 3,
          pick_number: 42
        end

        it 'after pick participant is still skipped' do
          subject

          expect(participant_pick_1.reload.cube_card).to eq cube_card
          expect(participant_pick_1.skipped).to eq false
          expect(participant_1.skipped?).to be true
        end
      end
    end

    context "when a skipped participant makes the draft's final pick" do
      let!(:participant_1) { create :draft_participant, draft: draft, draft_position: 1, skipped: true }
      let!(:final_pick) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: draft.rounds, pick_number: draft.rounds * 14, skipped: true }

      it "completes the draft without starting another turn" do
        expect(SkipActiveParticipantJob).not_to receive(:set)
        expect(PickNextQueuedPickJob).not_to receive(:set)

        subject

        expect(final_pick.reload.cube_card).to eq cube_card
        expect(draft.reload.status).to eq DraftStatus.completed
      end
    end

    context "when the participant is not on the clock" do
      let!(:filled_pick) { create :participant_pick, draft_participant: participant_1, round: 1, pick_number: 1 }
      let!(:other_pick) { create :participant_pick, draft_participant: participant_14, cube_card_id: nil, round: 1, pick_number: 2 }
      let!(:later_pick) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: 2, pick_number: 3 }

      it "rejects the pick without advancing the draft or enqueuing jobs" do
        expect(RemoveQueuedPicksJob).not_to receive(:perform_later)
        expect(Broadcast::DraftUpdateJob).not_to receive(:perform_later)

        expect { subject }.to raise_error(described_class::StalePick)
        expect(later_pick.reload.cube_card).to be_nil
        expect(draft.reload.last_pick_number).to eq 1
      end
    end

    context "when the intended pick was already made and the next one is also theirs" do
      let!(:filled_pick) { create :participant_pick, draft_participant: participant_1, round: 1, pick_number: 1 }
      let!(:back_to_back_pick) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: 2, pick_number: 2 }
      let(:participant_pick_id) { filled_pick.id }

      it "rejects the pick and leaves the second one open" do
        expect { subject }.to raise_error(described_class::StalePick)
        expect(back_to_back_pick.reload.cube_card).to be_nil
      end
    end

    context "when the card has already been picked" do
      let!(:taken_pick) { create :participant_pick, draft_participant: participant_14, cube_card:, round: 1, pick_number: 1 }
      let!(:open_pick) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: 1, pick_number: 2 }

      it "raises without changing the draft or enqueuing jobs" do
        expect(RemoveQueuedPicksJob).not_to receive(:perform_later)
        expect(Broadcast::DraftUpdateJob).not_to receive(:perform_later)

        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        expect(open_pick.reload.cube_card).to be_nil
        expect(draft.reload.last_pick_at).to be_nil
      end
    end

    context "locking" do
      let!(:open_pick) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: 1, pick_number: 1 }
      let!(:next_pick) { create :participant_pick, draft_participant: participant_14, cube_card_id: nil, round: 1, pick_number: 2 }

      it "makes its changes under the draft's row lock and enqueues jobs after releasing it" do
        allow(participant_1).to receive(:draft).and_return(draft)
        events = []
        allow(draft).to receive(:with_lock).and_wrap_original do |original, &block|
          original.call(&block).tap { events << :released }
        end
        allow(Broadcast::DraftUpdateJob).to receive(:perform_later) { events << :broadcast }

        subject

        expect(events.last(2)).to eq [ :released, :broadcast ]
      end
    end
  end
end
